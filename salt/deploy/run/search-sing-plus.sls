# uwsgi  /data/go_project/uwsgi/search.sing.plus          存放ini文件
# home   /data/go_projects/staging.search.sing.plus/venv  网站目录


{% set project =  pillar['project'] %}
{% set group   =  pillar[project]['group'] %}
{% set uwsgi   =  pillar[project]['uwsgi'] %}
{% set loger   =  pillar[project]['loger'] %}
{% set home    =  pillar[project]['home']  %}
{% set owner   =  pillar['website-owner'] %}


{% if group ==  'search_sing_plus'  %}

# 创建相关目录
search-uwsgi-dir:
    file.directory:
        - name: {{uwsgi}}/{{project}}
        - makedirs: True
        - user: {{owner}}
        - group: {{owner}}

search-loger-dir:
    file.directory:
        - name: {{loger}}
        - makedirs: True
        - user: {{owner}}
        - group: {{owner}}

search-uwsgi-ini:
    file.managed:
        - name: {{uwsgi}}/{{project}}.ini
        - source: salt://config/search/es-sing-plus-uwsgi.ini
        - user: {{owner}}
        - group: {{owner}}
        - template: jinja
        - defaults:
          home:  {{home}}/{{project}}
          uwsgi: {{uwsgi}}/{{project}}
          loger: {{loger}}/{{project}}
        - require:
          - file: search-uwsgi-dir
          - file: search-loger-dir

search-uwsgi-supervisor:
    file.managed:
      - name: /etc/supervisord.conf.d/search-uwsgi.conf
      - source: salt://service/search.sing.plus.conf
      - template: jinja
      - defaults:
          uwsgi: {{uwsgi}}
      - require:
        - file: search-uwsgi-ini

    cmd.run:
      - name: /usr/bin/supervisorctl update
      - watch:
        - file: search-uwsgi-supervisor

search-uwsgi-touch:
    cmd.run:
      - name: touch {{uwsgi}}/{{project}}.ini
      - runas: {{owner}}
      - require:
        - file: search-uwsgi-ini
{% endif %}
