{% set project = pillar['project'] %}
{% set nginx   = pillar['website-nginx'] %}
{% set group   = pillar[project]['group'] %}

{% if group !=  'cms-sing-plus' %}

nginx-file:
  file.managed:
    - name: {{nginx}}/{{project}}.conf
    - source: salt://nginx/{{group}}.conf
    - template: jinja
    - defaults:
       domain: {{project}}


nginx-reload:
  cmd.run:
    - name:  /usr/sbin/nginx -s reload
    - watch:
      - file: nginx-file

{% endif %}


