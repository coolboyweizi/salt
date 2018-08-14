base:
    '*':
        - base
        - user
        - python
        - vim
        - java
        - ssh
        - zabbix
        - hosts
libs:
    'fr-staging':
        - gnutls
        - lame
        - libass
        - libmodplug
        - nettle
        - schroedinger
        - SDL2
        - soxr
        - yasm

    'fr-cms*':
        - gnutls
        - lame
        - libass
        - libmodplug
        - nettle
        - schroedinger
        - SDL2
        - soxr
        - yasm



softs:
    '*':
        - openresty

    'dashboard':
        - mysql
        - redis
        - php
        - nodefinder
        - letsencrypt

    'fr-app*':
        - php
        - letsencrypt
        - nodefinder

    'fr-staging':
        - php
        - letsencrypt
        - nodefinder
        - mysql
        - ffmpeg
        - gocd
        - beanstalkd
        - elasticsearch
        - kibana
        - mongodb
        - redis

    'fr-go':
        - php
        - gocd

    'fr-log*':
        - letsencrypt
        - zookeeper
        - kafka

    'fr-log-s1':
        - mysql

    'mu-proxy':
        - mysql
        - redis
        - php
        - nodefinder
        - letsencrypt

    'fr-db*':
        - mysql
        - redis
        - mongodb

    'fr-db':
        - beanstalkd

    'fr-cms*':
        - php
        - letsencrypt
        - nodefinder
        - ffmpeg
        - gocd

    "fr-elastic":
        - php
        - letsencrypt
        - nodefinder
        - mysql
        - elasticsearch
        - kibana





