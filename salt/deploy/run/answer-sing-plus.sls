# scp from one minions


{% set project =  pillar['project'] %}
{% set group   =  pillar[project]['group'] %}
{% set env     =  pillar[project]['env']%}

{% if group ==  'answer_sing_plus'  %}

pm2-answer:
  file.managed:
    - name: /etc/supervisord.conf.d/pm2-answer.conf
    - source: salt://service/answer.sing.plus.conf
    - template: jinja
    - defaults:
       domain: {{project}}
       env:    {{env}}
    - require:
      - cmd: script-run

  cmd.run:
    - name: supervisorctl update pm2-answer && supervisorctl status pm2-answer
    - unless: supervisorctl restart pm2-answer && supervisorctl status pm2-answer
    - require:
      - file: pm2-answer


{% endif %}