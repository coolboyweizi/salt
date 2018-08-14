# scp from one minions


{% set project =  pillar['project'] %}
{% set group   =  pillar[project]['groupT'] %}
{% set env     =  pillar[project]['env']%}
{% set group  = pillar[project]['group'] %}

{% set nginx   = pillar['website-nginx'] %}

{% if group ==  'cms-sing-plus'  %}

{% set nginxT  = pillar[project]['nginxT'] %}


{% set celerys = pillar[project]['celery'] %}

{% for celery in celerys %}


{{celery}}:
    file.managed:
        - name: /etc/supervisord.conf.d/{{celery}}
        - source: /data/go_projects/{{project}}/celery/conf/{{celery}}
        - replace: False
        - require:
            - cmd: script-run

{% endfor %}

{% if nginxT == True %}
nginx-link:
    file.symlink:
        - name: {{nginx}}/{{project}}.conf
        - target: /data/go_projects/{{project}}/nginx/vhosts/sing.plus.nginx.conf
        - force: True
        - require:
            - cmd: script-run
{% endif %}

{% endif %}