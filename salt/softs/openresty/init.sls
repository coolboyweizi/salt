{% set cpu_num=grains['num_cpus'] %}
{% set GEOIP='GeoIP-1.4.8' %}
{% set OPENSSL='openssl-1.0.2k' %}
{% set OPENRESTY='openresty-1.11.2.3' %}

pkg-init:
    pkg.installed:
        - names:
            - pcre-devel
            - libxml2-devel
            - libxslt-devel
            - gd-devel
            - wget
            - curl
            - gcc
            - gcc-c++
            - glibc-devel
            - glibc-static
            - bzip2
            - bzip2-devel
            - unzip
            - zip
            - zlib-devel
            - libcurl-devel
            - automake
            - autoconf
            - libtool

geoIP-file:
    file.managed:
      - name: /data/soft/{{GEOIP}}.tar.gz
      - source: salt://common/packages/GeoIP.tar.gz

    cmd.run:
      - name: tar zxf {{GEOIP}}.tar.gz
      - cwd: /data/soft
      - require:
        - file: geoIP-file

geoIP-installed:
    cmd.run:
      - name: ./configure --prefix=/usr/local/{{GEOIP}} && make -j{{cpu_num}} && make -j{{cpu_num}} install
      - unless: test -x /usr/local/{{GEOIP}}/bin/geoiplookup
      - cwd: /data/soft/{{GEOIP}}
      - require:
          - cmd: geoIP-file

openssl-file:
    file.managed:
      - name: /data/soft/{{OPENSSL}}.tar.gz
      - source: salt://common/packages/{{OPENSSL}}.tar.gz

    cmd.run:
      - name: tar zxf {{OPENSSL}}.tar.gz
      - unless: test -d {{OPENSSL}}
      - cwd: /data/soft/
      - require:
          - file: openssl-file


openresty-file:
    file.managed:
      - name: /data/soft/{{OPENRESTY}}.tar.gz
      - source: salt://common/packages/{{OPENRESTY}}.tar.gz

    cmd.run:
      - name: tar zxf {{OPENRESTY}}.tar.gz
      - unless: test -d  {{OPENRESTY}}
      - cwd: /data/soft/
      - require:
        - file: openresty-file


openresty-install:
    cmd.run:
      - name:  ./configure --prefix=/usr/local/{{OPENRESTY}}  --with-stream  --with-pcre  --with-luajit  --with-poll_module  --with-threads --with-file-aio --with-http_realip_module --with-http_xslt_module --with-http_dav_module --with-http_auth_request_module  --with-http_gzip_static_module  --with-http_geoip_module  --with-http_sub_module  --with-mail  --with-mail_ssl_module  --with-cc-opt=-I/usr/local/{{GEOIP}}/include  --with-ld-opt=-L/usr/local/{{GEOIP}}/lib  --with-openssl=/data/soft/{{OPENSSL}}  --with-http_stub_status_module && make -j{{cpu_num}} && make -j{{cpu_num}} install
      - unless: test -x /usr/local/{{OPENRESTY}}/nginx/sbin/nginx
      - cwd: /data/soft/{{OPENRESTY}}
      - require:
        - cmd: openresty-file

openresty-link:
    cmd.run:
      - name: ln -s /usr/local/{{OPENRESTY}}/nginx/sbin/nginx /usr/sbin/
      - unless: test -L /usr/sbin/nginx
      - require:
        - cmd: openresty-install

openresty-vhosts:
    file.directory:
      - name: /usr/local/{{OPENRESTY}}/nginx/conf/vhosts
      - require:
        - cmd: openresty-install

openresty-etc:
    cmd.run:
      - name: ln -s /usr/local/{{OPENRESTY}}/nginx/conf /etc/nginx
      - unless: test -L /etc/nginx
      - require:
        - file: openresty-vhosts

openresty-conf:
    file.managed:
      - name: /usr/local/{{OPENRESTY}}/nginx/conf/nginx.conf
      - source: salt://common/config/openresty/nginx.conf
      - require:
        - cmd: openresty-install
      - template: jinja


openresty-supervisord:
    file.managed:
      - name : /etc/supervisord.conf.d/openresty.conf
      - source: salt://common/supervisor/example.conf
      - template: jinja
      - defaults:
        event_call: openresty
        event_cmd: /usr/sbin/nginx -c /usr/local/{{OPENRESTY}}/nginx/conf/nginx.conf
        event_dir: /tmp
        event_sign: TERM
        event_user: root

    cmd.run:
      - name: supervisorctl update
      - require:
        - file: openresty-supervisord
      - watch:
        - file: openresty-supervisord


http-template:
    file.managed:
      - name: /usr/local/{{OPENRESTY}}/nginx/conf/vhosts/http
      - source: salt://common/config/openresty/http
      - require:
        - file: openresty-conf


https-template:
    file.managed:
      - name: /usr/local/{{OPENRESTY}}/nginx/conf/vhosts/https
      - source: salt://common/config/openresty/https
      - require:
         - file: openresty-conf

letencrypt-template:
    file.managed:
      - name: /usr/local/{{OPENRESTY}}/nginx/conf/vhosts/_well-known-challenges.conf.fragment
      - source: salt://common/config/openresty/_well-known-challenges.conf.fragment
      - require:
         - file: openresty-conf


http-work:
    file.directory:
      - name: /data/www
      - user: nobody
      - group: nobody

http-log:
    file.directory:
      - name: /data/log/openresty
      - user: root
      - group: root
      - mode: 755