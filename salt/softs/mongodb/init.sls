{% set mongodb = "mongodb-3.4.4" %}
{% set version = "mongodb-linux-x86_64-rhel70-3.4.4" %}

mongodb_install:
    user.present:
        - name: mongodb
        - uid: 993
        - gid: 993
        - home: /data/log/mongodb
        - shell: /sbin/nologin
        - require:
          - group: mongodb_install

    group.present:
        - name: mongodb
        - gid:  993

    archive.extracted:
        - name: /data/soft/
        - source: salt://common/packages/{{version}}.tgz
        - user: mongodb
        - group: mongodb
        - require:
            - user: mongodb_install

    file.copy:
        - name: /usr/local/{{mongodb}}
        - source: /data/soft/{{version}}
        - user: mongodb
        - group: mongodb
        - require:
            - archive: mongodb_install

    cmd.run:
        - name : test -L /usr/bin/mongo
        - unless: ln -s /usr/local/{{mongodb}}/bin/mongo /usr/bin/mongo
        - require:
            - file: mongodb_install


mongodb_data:
    file.directory:
        - name : /data/mongodb
        - user : mongodb
        - group: mongodb
        - require:
            - user: mongodb_install

mongodb_run:
    file.managed:
        - name: /etc/supervisord.conf.d/mongodb.conf
        - source: salt://common/supervisor/example.conf
        - template: jinja
        - defaults:
            event_call: mongodb
            event_cmd:  /usr/local/{{mongodb}}/bin/mongod  --dbpath=/data/mongodb --unixSocketPrefix=/dev/shm --maxConns=200 --logpath=/data/log/mongodb/mongodb.log
            event_dir:  /usr/local/{{mongodb}}
            event_sign: QUIT
            event_user: mongodb
        - require:
            - file: mongodb_data

    cmd.run:
        - name: supervisorctl update mongodb
        - require:
            - file: mongodb_run

