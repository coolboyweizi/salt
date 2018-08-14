{% set es_user = "es" %}
{% set es_uid  = 830 %}
{% set es_gid  = 830 %}
{% set es_file = "elasticsearch-5.5.0.zip" %}
{% set es_work = "/usr/local/elasticsearch-5.5.0" %}
{% set es_path = "/data/es" %}


es-env:
  cmd.run:
      - name: java -version

es-user:
  group.present:
      - name: {{es_user}}
      - gid: {{es_gid}}
      - system: True
      - require:
          - cmd: es-env

  user.present:
      - name: {{es_user}}
      - gid: {{es_gid}}
      - uid: {{es_uid}}
      - require:
          - group: es-user

es-path:
  file.directory:
      - name: {{es_path}}
      - user: {{es_uid}}
      - group: {{es_gid}}
      - makedirs: True
      - require:
          - user: es-user

es-path-data:
  file.directory:
      - name: {{es_path}}/data
      - user: {{es_uid}}
      - group: {{es_gid}}
      - makedirs: True
      - require:
          - user: es-user

es-path-log:
  file.directory:
      - name: {{es_path}}/log
      - user: {{es_uid}}
      - group: {{es_gid}}
      - makedirs: True
      - require:
          - user: es-user


es-package:
  archive.extracted:
      - name: /data/soft/
      - source: salt://common/packages/{{es_file}}
      - user: {{es_uid}}
      - group: {{es_gid}}
      - require:
          - user: es-user

  cmd.run:
      - name: mv /data/soft/elasticsearch-5.5.0 {{es_work}}
      - unless: test -d {{es_work}}/elasticsearch-5.5.0
      - cwd: /data/soft
      - require:
          - archive: es-package

  # if config has exit . does not replace
  file.managed:
    - name: {{es_work}}/config/elasticsearch.yml
    - source: salt://common/config/elasticsearch.yml
    - template: jinja
    - replace:  false
    - defaults:
        es_data: {{es_path}}/data
        es_log:  {{es_path}}/log
    - require:
      - cmd: es-package

es-supervisor:
  file.managed:
    - name: /etc/supervisord.conf.d/elastic.conf
    - source: salt://common/supervisor/example.conf
    - template: jinja
    - defaults:
        event_user: {{es_user}}
        event_call: elastic
        event_dir:  {{es_work}}
        event_cmd: {{es_work}}/bin/elasticsearch
        event_sign: QUIT
    - require:
        - file: es-package

  cmd.run:
    - name: supervisorctl update elastic
    - watch:
      - file: es-supervisor

es-xpack:
  cmd.run:
    - name: {{es_work}}/bin/elasticsearch-plugin install x-pack
    - runas: {{es_user}}
    - unless: test -x {{es_work}}/bin/x-pack/certgen
    - require:
      - cmd: es-supervisor








