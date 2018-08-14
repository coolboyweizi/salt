#!/usr/bin/env bash

letsencrypt=`which letsencrypt-auto`
if [ ! -x $letsencrypt ];then
  echo " 需要letsencrypt-auto软件支持，google查找下载"
  exit 0
fi

DOMAIN=$1
WEBROOT=/data/www/_challenges-5817040be49bd
VHOSTS=/etc/nginx/vhosts/


mkdir -p ${WEBROOT}


INITLIZED=0

if [ ! -f "${VHOSTS}/${DOMAIN}.conf" ];then
    echo "初始化${DOMAIN}.conf的http配置文件"
    cp ${VHOSTS}/http ${VHOSTS}/${DOMAIN}.conf
    if [ $? -ne 0 ];then
        echo "初始化{DOMAIN}.conf的http配置文件失败"
        exit 1 
    fi
    sed -i "s!domain!${DOMAIN}!g" ${VHOSTS}/${DOMAIN}.conf
    nginx -s reload
    INITLIZED=1
fi

letsencrypt-auto certonly -d ${DOMAIN} --webroot -w ${WEBROOT} --agree-tos
if [ $? -ne 0 ];then
  echo "生成证书失败"
  if [ ${INITLIZED} -eq 1 ];then
    rm -rf ${VHOSTS}/${DOMAIN}.conf
  fi
  exit 1
fi

if [ ${INITLIZED} -eq 1 ];then

  echo "初始化:生成${DOMAIN}.conf的https配置文件"
  cp ${VHOSTS}/https ${VHOSTS}/${DOMAIN}.conf
  sed -i "s!domain!${DOMAIN}!g" ${VHOSTS}/${DOMAIN}.conf
  nginx -s reload

fi

if [ $? -ne 0 ];then
  echo "生成证书失败"
  if [ ${INITLIZED} -eq 1 ];then
    rm -rf ${VHOSTS}/${DOMAIN}.conf
  fi
  exit 1
else
    echo "生成${DOMAIN}证书成功"
fi

nginx -s reload

