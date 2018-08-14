{% set cpu_num = grains['num_cpus'] %}
{% set version = '3.2.1' %}
{% set zabuser = 'zabbix' %}
{% set logfile = '/data/log/zabbix' %}
{% set pidfile = '/data/log/zabbix' %}
{% set prefix  = '/usr/local/zabbix-3.2.1' %}

zabbix-user:
  user.present:
    - name: {{zabuser}}
    - uid: 600
    - gid: 100
    - shell: /sbin/nologin
    - home: /home/zabbix

zabbix-pid:
  file.directory:
    - name: {{pidfile}}
    - user: {{zabuser}}
    - group: users
    - require:
      - user: zabbix-user

zabbix-log:
  file.directory:
    - name: {{logfile}}
    - user: {{zabuser}}
    - group: users
    - require:
      - user: zabbix-user


zabbix-packages:

  archive.extracted:
    - name: /data/soft
    - source: salt://common/packages/zabbix-{{version}}.tar.gz


zabbix-configure:
  cmd.run:
  {% if pillar['zabbix-server-id'] ==  grains['id'] %}

    {% if pillar['zabbix-master'] ==  1 %}
    - name: ./configure --prefix={{prefix}}  --enable-server --enable-agent --with-libcurl --with-libxml2 --with-mysql=/usr/local/mysql/bin/mysql_config && make -j{{cpu_num}} && make -j{{cpu_num}} install
    {% else %}
    - name: ./configure --prefix={{prefix}}  --enable-server --enable-agent --enable-proxy --with-libcurl --with-libxml2 --with-mysql=/usr/local/mysql/bin/mysql_config && make -j{{cpu_num}} && make -j{{cpu_num}} install
    {% endif %}

  {% else %}
    - name: ./configure --prefix={{prefix}}  --enable-agent && make -j{{cpu_num}} && make -j{{cpu_num}} install
  {% endif %}
    - cwd: /data/soft/zabbix-{{version}}


# zabbix-config  ALL Services
zabbx-agent-config:
  file.managed:
    - name: {{prefix}}/etc/zabbix_agentd.conf
    - source: salt://common/config/zabbix/zabbix_agent.conf
    - template: jinja
    - defautls:
      pidfile: {{pidfile}}
      logfile: {{logfile}}
    - require:
      - cmd: zabbix-configure

# zabbix-agent running
zabbix-agent-supervisord:
  file.managed:
    - name: /etc/supervisord.conf.d/zabbix_agent.conf
    - source: salt://common/supervisor/zabbix/zabbix_agent.conf
    - template: jinja
    - defautls:
      pidfile: {{pidfile}}
      logfile: {{logfile}}
      prefix:  {{prefix}}
    - require:
      - cmd: zabbix-configure
      - user: zabbix-user
  cmd.run:
    - name: supervisorctl update
    - onlyif: which supervisorctl


{% if pillar['zabbix-server-id'] ==  grains['id'] %}

# init Database

zabbix-server-config:
  file.managed:
    {% if pillar['zabbix-master'] ==  1 %}
    - name: {{prefix}}/etc/zabbix_server.conf
    - source: salt://common/config/zabbix/zabbix_server.conf

    {% else %}
    - name: {{prefix}}/etc/zabbix_proxy.conf
    - source: salt://common/config/zabbix/zabbix_proxy.conf
    {% endif %}

    - template: jinja
    - defautls:
      pidfile: {{pidfile}}
      logfile: {{logfile}}
      prefix:  {{prefix}}


zabbix-server-supervisord:
  file.managed:
    {% if pillar['zabbix-master'] ==  1 %}
    - name: /etc/supervisord.conf.d/zabbix_server.conf
    - source: salt://common/supervisor/zabbix/zabbix_server.conf
    {% else %}
    - name: /etc/supervisord.conf.d/zabbix_proxy.conf
    - source: salt://common/supervisor/zabbix/zabbix_proxy.conf
    {% endif %}
    - template: jinja
    - defautls:
      pidfile: {{pidfile}}
      logfile: {{logfile}}
      prefix:  {{prefix}}


  cmd.run:
    - name: supervisorctl update
    - onlyif: which supervisorctl
    - require:
      - file: zabbix-server-config
      - file: zabbix-server-supervisord
    - watch:
      - file: zabbix-server-supervisord

{% endif %}
