#!/usr/bin/env python
#coding=utf-8
'''
    Suprevisord Listener example.
'''

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import os
import datetime

from wx_python import send_msg
from config import data

PART_ID  = str(data['PART_ID'])
APP_ID   = int(data['APP_ID'])
HOSTNAME = data['HOSTNAME']

EVENT_STATE = {
    'PROCESS_STATE_EXITED' : 'EXITED',
    'PROCESS_STATE_RUNNING': 'RUNNING',
    'PROCESS_STATE_FATAL'  : 'FATAL' ,
    'PROCESS_STATE_BACKOFF': 'BACKOFF',
    'PROCESS_STATE_STOPPING': 'STOPPING',
    'PROCESS_STATE_STOPPED': 'STOPPED',
    'PROCESS_STATE_UNKNOWN': 'UNKNOWN' ,
    'PROCESS_STATE_STARTING': 'STARTING' ,
}


def write_stdout(s):
    sys.stdout.write(s)
    sys.stdout.flush()

def write_stderr(s):
    sys.stderr.write(s+"\n")
    sys.stderr.flush()

def main():

    if not 'SUPERVISOR_SERVER_URL' in os.environ:
        print "%s must be run as a supervisor listener." % sys.argv[0]
        return

    while True:
        write_stdout('READY\n')

        line = sys.stdin.readline()
        # ver:3.0 server:supervisor serial:2951 pool:listener poolserial:261  eventname:PROCESS_STATE_RUNNING len:67
        headers = dict([ x.split(':') for x in line.split() ])

        # processname:pymysql groupname:pymysql from_state:RUNNING expected:0 pid:29110
        process_data = sys.stdin.read(int(headers['len']))
        process_info = dict([ x.split(':') for x in process_data.split()])

        write_stderr(str(process_info))

        send_data = [
            "服务器%s进程发生改变" %(HOSTNAME),
            "运行服务:%s,pid:%d" %(process_info['processname'], int(process_info.get('pid',0))),
            "上次状态:%s" %(process_info['from_state']),
            "当前状态:%s" %(EVENT_STATE[headers['eventname']]),
            "发生时间:%s" %(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        ]

        # 尝试10次发送
        num = 10
        while num > 0 :
            try:
                rs = send_msg("\n".join(send_data).encode('utf-8'), APP_ID, PART_ID)
                write_stderr(rs)
                num = 0
            except:
                num = num - 1


        write_stdout('RESULT 2\nOK')

if __name__ == '__main__':
    main()

