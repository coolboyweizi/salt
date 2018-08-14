{% set version = '3.2.8' %}
{% set redislog = '/data/log/redis' %}

{% set cache = pillar.get('redis-cache','false') %}
{% set counter = pillar.get('redis-counter','false') %}
{% set im = pillar.get('redis-im','false') %}
{% set cms = pillar.get('redis-cms','false') %}


redis-install:
    group.present:
        - name: redis
        - gid: 994

    user.present:
        - name: redis
        - gid: 994
        - uid: 994
        - home: /var/lib/redis
        - shell: /sbin/nologin
        - require:
          - group: redis-install

    archive.extracted:
        - name: /data/soft/
        - source: salt://common/packages/redis-{{version}}.tar.gz

    file.copy:
        - name: /usr/local/redis-{{version}}
        - source: /data/soft/redis-{{version}}
        - user: redis
        - group: redis
        - require:
            - user: redis-install
            - archive: redis-install

    cmd.run:
        - name: make MALLOC=libc
        - unless: test -x /usr/local/redis-{{version}}/src/redis-server
        - cwd: /usr/local/redis-{{version}}
        - require:
            - file: redis-install
redis-log:
    file.directory:
        - name: {{redislog}}
        - user: redis
        - group: redis
        - require:
            - user: redis-install

{% for type in pillar.get('redis') %}
redis-{{type}}-config:
    file.managed:
        - name: /etc/redis-{{type}}.conf
        - source: salt://common/config/redis/{{type}}.conf
        - user: redis
        - group: redis
        - template: jinja
        - require:
            - cmd: redis-install
            - file: redis-log

redis-{{type}}-supervisor:
    file.managed:
        - name: /etc/supervisord.conf.d/redis-{{type}}.conf
        - source: salt://common/supervisor/example.conf
        - template: jinja
        - defaults:
            event_call: redis-{{type}}
            event_cmd: /usr/local/redis-{{version}}/src/redis-server /etc/redis-{{type}}.conf
            event_dir:  /var/lib/redis
            event_sign: QUIT
            event_user: redis
        - require:
            - cmd: redis-install

    cmd.run:
        - name: supervisorctl update redis-{{type}}
        - require:
          - file: redis-{{type}}-supervisor
{% endfor %}

