{% set cpu_num=grains['num_cpus'] %}


# Package For Percona
percona_boost:
    archive.extracted:
        - name: /data/soft
        - source: salt://common/packages/boost_1_59_0.tar.gz
        - user: root
        - group: root

percona_code:
    archive.extracted:
        - name: /data/soft
        - source: salt://common/packages/Percona-Server-5.7.17-13-Linux.x86_64.ssl101.tar.gz
        - user: root
        - group: root

# Create User For Mysql
percona-before:
    group.present:
      - name: mysql
      - gid: 991

    user.present:
      - name: mysql
      - uid: 991
      - gid: 991
      - shell: /sbin/nologin
      - home: /home/mysql
      - require:
        - group: percona-before

    file.directory:
      - name: /data/dbdata
      - user: mysql
      - group: mysql
      - clean: false      # must need it
      - require:
        - user: percona-before


    pkg.installed:
      - names:
        - numactl-libs
        - libaio-devel
# Judge whether there is Execution Authority. Or Install
percona-installed:

    # If the target location is present then the file will not be moved
    file.copy:
      - name: /usr/local/mysql
      - source: /data/soft/Percona-Server-5.7.17-13-Linux.x86_64.ssl101
      - force: flase
      - user: mysql
      - group: mysql

    cmd.run:
      - unless: test -d /data/dbdata/mysql
      - name: /usr/local/mysql/bin/mysqld --initialize-insecure --datadir=/data/dbdata --user=mysql
      - runas: mysql
      - require:
        - file: percona-installed


# Update mysql my.cnf
percona-cnf:
    file.managed:
      - name: /etc/my.cnf
      - source: salt://common/config/percona.cnf
      - require:
        - cmd: percona-installed

# update && restart percona
percona-service:
    file.managed:
      - name: /etc/supervisord.conf.d/percona.conf
      - source: salt://common/supervisor/example.conf
      - template: jinja
      - require:
        - cmd: percona-installed
      - defaults:
        event_call: percona
        event_cmd: /usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf
        event_dir: /tmp
        event_sign: TERM
        event_user: mysql

    cmd.run:
      - name: supervisorctl restart percona
      - unless: supervisorctl update percona
      - require:
        - file: percona-service

percona-php:
    cmd.run:
      - name: ln -s lib lib64
      - unless: test -L /usr/local/mysql/lib64
      - cwd: /usr/local/mysql
      - require:
          - cmd: percona-installed

percona-lib:
  cmd.run:
      - name: test -L libmysqlclient.a
      - unless: |
          ln -s libperconaserverclient.a libmysqlclient.a
          ln -s libperconaserverclient.so.20.3.4 libmysqlclient.so.20.3.3
          ln -s libmysqlclient.so.20.3.3 libmysqlclient.so.20
          ln -s libmysqlclient.so.20 libmysqlclient.so
      - cwd: /usr/local/mysql/lib
      - require:
        - cmd: percona-installed

