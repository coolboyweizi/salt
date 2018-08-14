{% set log = '/data/log/supervisor' %}

appdirs:
    archive.extracted:
      - name: /data/soft
      - source: salt://common/packages/appdirs-1.4.3.tar.gz

    cmd.run:
      - name:  python setup.py install
      - cwd: /data/soft/appdirs-1.4.3
      - unless: pip list | grep appdirs


pyparsing:
    archive.extracted:
      - name: /data/soft
      - source: salt://common/packages/pyparsing-2.2.0.tar.gz

    cmd.run:
      - name:  python setup.py install
      - cwd: /data/soft/pyparsing-2.2.0
      - unless: pip list | grep pyparsing

packaging:
    archive.extracted:
      - name: /data/soft
      - source: salt://common/packages/packaging-16.8.tar.gz

    cmd.run:
      - name:  python setup.py install
      - cwd: /data/soft/packaging-16.8
      - unless: pip list | grep packaging


six:
    archive.extracted:
      - name: /data/soft
      - source: salt://common/packages/six-1.10.0.tar.gz

    cmd.run:
      - name:  python setup.py install
      - cwd: /data/soft/six-1.10.0
      - unless: pip list | grep six

setuptools:
    archive.extracted:
      - name: /data/soft
      - source: salt://common/packages/setuptools-34.3.3.zip
      - use_cmd_unzip: True

    cmd.run:
      - name:  python setup.py install
      - cwd: /data/soft/setuptools-34.3.3
      - unless: pip list | grep six

pip:
    archive.extracted:
      - name: /data/soft
      - source: salt://common/packages/pip-9.0.1.tar.gz

    cmd.run:
      - name:  python setup.py install
      - cwd: /data/soft/pip-9.0.1
      - unless: which pip

supervisord:
    cmd.run:
      - name: pip install supervisor
      - require:
        - cmd: pip
      - unless: which supervisord

supervisord_conf:
    file.managed:
      - name: /etc/supervisord.conf
      - source: salt://common/supervisor/supervisord.conf
      - template: jinja
      - default:
        log: {{log}}
      - mode: 644
      - user: root

supervisord_conf_ext:
    file.directory:
      - name: /etc/supervisord.conf.d
      - mkdirs: true
      - dir_mode: 755
      - user: root
      - group: root

supervisord_log:
    file.directory:
      - name: {{log}}
      - mkdirs: true
      - dir_mode: 755
      - user: root
      - group: root
      - unless: test -d /data/log/supervisor

supervisord_service:

    file.managed:
      - name: /etc/systemd/system/supervisord.service
      - source: salt://common/supervisor/supervisord.service


supervisord_run:
    #cmd.run:
    #  - name: supervisord -c /etc/supervisord.conf.d
    #  - unless: test -f /dev/shm/supervisord.sock
    file.symlink:
      - name: /etc/systemd/system/multi-user.target.wants/supervisord.service
      - target: /etc/systemd/system/supervisord.service
      - force: False
    cmd.run:
      - name: systemctl daemon-reload && systemctl enable supervisord && systemctl start supervisord

