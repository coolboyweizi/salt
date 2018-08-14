{% set kibana_work = "/usr/local/kibana-5.5.0" %}
{% set kibana_user = "es" %}
{% set es_user = "es" %}
{% set es_uid  = 830 %}
{% set es_gid  = 830 %}


kibana-user:
  group.present:
      - name: {{es_user}}
      - gid: {{es_gid}}
      - system: True

  user.present:
      - name: {{es_user}}
      - gid: {{es_gid}}
      - uid: {{es_uid}}
      - require:
          - group: kibana-user

kibana-work:
  file.directory:
    - name: {{kibana_work}}
    - user: {{es_uid}}
    - group: {{es_gid}}
    - mode: 755
    - require:
      - user: kibana-user

kibana-package:
  archive.extracted:
    - name: /data/soft
    - source: salt://common/packages/kibana-5.5.0-linux-x86_64.tar.gz
    - gid: {{es_gid}}
    - uid: {{es_uid}}

  cmd.run:
    - name: mv /data/soft/kibana-5.5.0-linux-x86_64/* {{kibana_work}} && chown es.es -R {{kibana_work}}
    - unless: test -x {{kibana_work}}/bin/kibana
    - cwd: /data/soft


kibana-xpack:
  cmd.run:
    - name: {{kibana_work}}/bin/kibana-plugin install x-pack
    - unless: test -d {{kibana_work}}/plugins/x-pack
    - runas: {{kibana_user}}
    - require:
      - cmd: kibana-package


kibana-config:
  cmd.run:
    - name: chown -R {{kibana_user}}.{{kibana_user}} -R {{kibana_work}}
    - require:
      - cmd: kibana-xpack

  file.managed:
    - name: {{kibana_work}}/config/kibana.yml
    - source: salt://common/config/kibana.yml
    - template: jinja
    - require:
      - cmd: kibana-config


kibana-supervisor:
  file.managed:
    - name: /etc/supervisord.conf.d/kibana.conf
    - source: salt://common/supervisor/example.conf
    - template: jinja
    - defaults:
        event_user: {{kibana_user}}
        event_call: kibana
        event_dir:  {{kibana_work}}
        event_cmd:  {{kibana_work}}/bin/kibana
        event_sign: quit
    - require:
        - file: kibana-config

  cmd.run:
    - name: supervisorctl update kibana
    - watch:
      - file: kibana-supervisor


