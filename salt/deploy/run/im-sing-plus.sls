# scp from one minions


{% set project =  pillar['project'] %}
{% set group   =  pillar[project]['group'] %}
{% set env     =  pillar[project]['env']%}

{% if group ==  'im_sing_plus'  %}

pm2-im:
  file.managed:
    - name: /etc/supervisord.conf.d/pm2-im.conf
    - source: salt://service/im.sing.plus.conf
    - template: jinja
    - defaults:
       domain: {{project}}
       env:    {{env}}
    - require:
      - cmd: script-run

  cmd.run:
    - name: supervisorctl update pm2-im && supervisorctl status pm2-im
    - unless: supervisorctl restart pm2-im && supervisorctl status pm2-im
    - watch:
      - file: /etc/supervisord.conf.d/pm2-im.conf


{% endif %}