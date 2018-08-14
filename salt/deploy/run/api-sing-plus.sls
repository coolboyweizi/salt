# scp from one minions

{% set project =  pillar['project'] %}
{% set group   =  pillar[project]['group'] %}

{% if group ==  'api_sing_plus'  %}

sing-worker:
  file.managed:
    - name: /etc/supervisord.conf.d/sing-worker.conf
    - source: salt://service/sing-worker.conf
    - template: jinja
    - defaults:
       domain: {{project}}
    - require:
      - cmd: script-run

  cmd.run:
    - name: supervisorctl restart sing-work
    - unless: supervisorctl update
    - require:
      - file: sing-worker

sing-worker-push:
  file.managed:
    - name: /etc/supervisord.conf.d/sing-worker-push.conf
    - source: salt://service/sing-worker-push.conf
    - template: jinja
    - defaults:
       domain: {{project}}
    - require:
      - cmd: script-run

  cmd.run:
    - name: supervisorctl restart sing-worker-push
    - unless: supervisorctl update
    - require:
      - file: sing-worker-push


sing-worker-hierarchy:
  file.managed:
    - name: /etc/supervisord.conf.d/sing-worker-hierarchy.conf
    - source: salt://service/sing_worker_hierarchy.conf
    - template: jinja
    - defaults:
       domain: {{project}}
    - require:
      - cmd: script-run

  cmd.run:
    - name: supervisorctl restart sing-worker-hierarchy
    - unless: supervisorctl update
    - require:
      - file: sing-worker-push

api-php-reload:
  cmd.run:
    - name:  supervisorctl signal USR2 php-fpm
    - require:
      - cmd: script-run

{% endif %}