beanstalkd-prepare:

    group.present:
        - name: beanstalkd
        - gid: 929

    user.present:
        - name: beanstalkd
        - gid: 929
        - uid: 929
        - home: /var/lib/beanstalkd
        - shell: /sbin/nologin
        - require:
            - group: beanstalkd-prepare

    file.directory:
        - name: /data/log/beanstalkd
        - user: beanstalkd
        - group: beanstalkd
        - mode: 755

beanstalkd-install:
    archive.extracted:
        - name: /data/soft/
        - source: salt://common/packages/beanstalkd-1.10.tar.gz

    cmd.run:
        - name: test -x /usr/local/bin/beanstalkd
        - unless: make && make install
        - cwd: /data/soft/beanstalkd-1.10
        - require:
          - archive: beanstalkd-install

    file.managed:
        - name: /etc/supervisord.conf.d/beanstalkd.conf
        - source: salt://common/supervisor/example.conf
        - defaults:
          event_call: beanstalkd
          event_cmd: /usr/local/bin/beanstalkd -b/data/log/beanstalkd -f0 -l{{grains['ip4_interfaces']['eth0'][0]}} -p11311 -ubeanstalkd
          event_dir: /data/log/beanstalkd
          event_sign: QUIT
          event_user: beanstalkd
        - template: jinja
        - require:
            - cmd: beanstalkd-install

    supervisord.running:
        - name: beanstalkd
        - watch:
            - file: /etc/supervisord.conf.d/beanstalkd.conf