#!/usr/bin/env python
#coding:utf-8

import os
import requests
import time
import json
import hashlib
import sys
import shutil
from hashlib import md5
from pysalt import Grains

try:
  import cookielib
except:
  import http.cookiejar as cookielib

# 使用urllib2请求https出错，做的设置
import ssl
context = ssl._create_unverified_context()

from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)


salt_api = "https://172.30.1.10:8080/"

class SaltApi:
    """
    定义salt api接口的类
    初始化获得token
    """
    def __init__(self, url):
        self.url = url
        self.username = "salt"
        self.password = "saltm"
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
            "Content-type": "application/json"
            # "Content-type": "application/x-yaml"
        }
        self.params = {'client': 'local', 'fun': '', 'tgt': ''}
        # self.params = {'client': 'local', 'fun': '', 'tgt': '', 'arg': ''}
        self.login_url = salt_api + "login"
        self.login_params = {'username': self.username, 'password': self.password, 'eauth': 'pam'}
        self.token = self.get_data(self.login_url, self.login_params)['token']
        self.headers['X-Auth-Token'] = self.token

    def get_data(self, url, params):
        send_data = json.dumps(params)
        request = requests.post(url, data=send_data, headers=self.headers, verify=False)
        response = request.text
        # response = eval(response)     使用x-yaml格式时使用这个命令把回应的内容转换成字典
        # print response
        # print request
        #print type(request)
        response = request.json()
        result = dict(response)
        # print result
        return result['return'][0]

    def salt_command(self, tgt, method,expr_form='glob', arg=None, kwarg=None):
        if kwarg:
            params = {'client': 'local', 'fun': method, 'expr_form':expr_form, 'tgt': tgt, 'kwarg': kwarg}
        elif arg:
            params = {'client': 'local', 'fun': method, 'expr_form':expr_form, 'tgt': tgt, 'arg':arg}
        else :
            params = {'client': 'local', 'fun': method, 'expr_form':expr_form, 'tgt': tgt}

        result = self.get_data(self.url, params)
        return result


def logger(data):
    obj=open('/tmp/go/'+str(time.time()),'a+')
    obj.write(data)
    obj.flush()
    obj.close()

# toolbar到指定路径去
def mv(src,project, item):
    dst='/srv/salt/deploy/packages'
    if os.path.exists(os.sep.join((dst,project))) == False:
      os.mkdir(os.sep.join((dst,project)))
    # 使用salt去push 权限就好了
    shutil.copyfile(src, os.sep.join((dst,project, item)))

# MD5文件校正函数
def md5sum(filename):
    m = md5()
    a_file = open(filename, 'rb')
    m.update(a_file.read())
    a_file.close()
    return m.hexdigest()



def showRs(key,item):
    print "----------"
    if item.get('result') == False:
        print('\033[1;31;1m')
    else:
        print('\033[1;32;1m')

    def text(pre,nex,length=10):
        return ":".join((pre.rjust(length)," "*3+nex.ljust(length)))

    exectable = key.split("_|-")

    print text("id",  exectable[1])
    print text("function", exectable[0]+"."+exectable[3])
    print text("name", exectable[2])

    print text("result", ("True" if item.get('result',"None") else "False"))
    print text("comment",(item.get("comment","None")))

    changes = item.get("changes")
    if len(changes) > 0 :
        print text("retcode",str(changes.get('retcode',0)))
        print text("stderr", changes.get('stderr', "None"))
        print text("stdout", changes.get('stdout', "None"))

    print text("start_time",item.get("start_time","None"))
    print text("duration",  str(item.get("duration","0")))

    print('\033[0m')
    return item.get('result')


def runJob(salt,salt_dest, salt_method, salt_params) :
    runRs = salt.salt_command(salt_dest, salt_method, 'pillar', None, salt_params)
    #logger(str(runRs))
    # 循环输出结果
    for minion in runRs.keys():
        result = runRs.get(minion)
        print minion

        if result == False:
          print '%s error' %(minion)

        count = {"success": 0, "failure": 0}

        try:

            rs = sorted(result.items(), key=lambda x: x[1]['__run_num__'], reverse=False)
            for key in rs:
                if (showRs(key[0], key[1])):
                    count["success"] += 1
                else:
                    count["failure"] += 1
            if count["failure"] > 0:
                sys.stderr.write("Summary for %s \n".ljust(10) % minion)
                sys.stderr.write("Succeeded: %d \n".ljust(10) % count["success"])
                sys.stderr.write("Failer: %d\n".ljust(10) % count["failure"])
                sys.exit(1)
            else:
                sys.stdout.write("Summary for %s \n".ljust(10) % minion)
                sys.stdout.write("Succeeded: %d \n".ljust(10) % count["success"])
                sys.stdout.write("Failer: %d \n".ljust(10) % count["failure"])

        except BaseException as e:

            print e
            #for items in result:
            #    sys.stderr.write(items+"\n")
            sys.exit(1)


def main():
    print '================================================='


    project = sys.argv[1]  # 项目域名
    environ = sys.argv[2]  # 项目环境
    artifact = sys.argv[3]  # 项目包
    deploysh = sys.argv[4]  # 项目部署脚本

    package=artifact.split(os.sep)[-1]
    scripts=deploysh.split(os.sep)[-1]
    #package=${artifact##*/}
    #scripts=${deploysh##*/}

    mv(deploysh,project, scripts)
    mv(artifact,project, package)

    # 项目发布
    salt_primary   = ':'.join([project,environ,'primary'])
    salt_secondary = ':'.join([project,environ,'secondary'])
    salt_method = 'state.apply'
    salt_params = {
        'mods':'run',
        'saltenv':'deploy',
        'concurrent':True,
        'pillar': {
          'project':project,
          'scripts': scripts,
          'package': package,
          'hash_s': md5sum(deploysh),
          'hash_p': md5sum(artifact),
          'artifact': artifact,
          'deploysh': deploysh
        }
    }

    salt = SaltApi(salt_api)
    runJob(salt, salt_primary, salt_method, salt_params)
    runJob(salt, salt_secondary, salt_method, salt_params)
    del salt


if __name__ == '__main__':
    main()




