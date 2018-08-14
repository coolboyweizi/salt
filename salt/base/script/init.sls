{% set inotify = '/usr/local/notification' %}

work_dir:
  file.directory:
    - name: {{inotify}}
    - unless: test -d {{inotify}}
    - makedirs: true


script-package:
  file.managed:
    - name : {{inotify}}/inotify.zip
    - source: salt://script/files/inotify.zip
    - require:
      - file: work_dir
  cmd.run:
    - name: unzip -o inotify.zip && rm -rf inotify.zip
    - cwd:  {{inotify}}
    - require:
      - file: script-package

script-config:
  file.managed:
    - name : {{inotify}}/config.json
    - source: salt://script/files/config.json
    - template: jinja
    - require:
      - file: work_dir

supervisor_inotify:
    file.managed:
      - name: /etc/supervisord.conf.d/alert.conf
      - source: salt://common/supervisor/alert.conf
      - template: jinja

    cmd.run:
      - name: /usr/bin/supervisorctl update && /usr/bin/supervisorctl restart events-listen
