{% set cpu_num =  grains['num_cpus'] %}
{% set version =  "7.1.3" %}
{% set prefix  =  "/usr/local/php-7.1.3" %}
{% set logdir  =  "/data/log/php" %}

include:
    - php.pkg
    - php.composer
    - php.pecl

# php prefix directory
php-dir:
    file.directory:
        - name: {{prefix}}
        - user:  root
        - group: root

# php log directory
php-log:
    file.directory:
        - name: {{logdir}}
        - user: nobody
        - group: nobody


# php install dir
php-installed:
    archive.extracted:
        - name: /data/soft/
        - source: salt://common/packages/php-{{version}}.tar.gz
        - user: root
        - group: root

    cmd.script:
        - source: salt://php/install.sh
        - unless: test -x {{prefix}}/bin/php
        - cwd: /data/soft/php-{{version}}
        - template: jinja
        - defaults:
          prefix: {{prefix}}
          cpu_num: {{cpu_num}}
        - require:
          - file: php-pkg-tidy
          - file: php-pkg-mhash
          - file: php-pkg-libmcrypt
          - pkg: php-pkg
          - archive: php-installed

    file.managed:
        - name: {{prefix}}/etc/php-fpm.conf
        - source: salt://common/config/php-fpm/php-fpm.conf
        - template: jinja
        - mode: 644
        - user: root
        - group: root
        - require:
          - cmd: php-installed
        - template: jinja
        - defaults:
          php_log: {{logdir}}
          php_prefix: {{prefix}}

# create symlink
php-symlink:
    file.symlink:
        - name: /usr/bin/php
        - target: {{prefix}}/bin/php
        - force: True
        - require:
          - cmd: php-installed
    cmd.run:
        - name: test -L /usr/bin/pecl
        - unless: ln -s {{prefix}}/bin/pecl /usr/bin
        - require:
          - cmd: php-installed

php-www:
    file.managed:
        - name: {{prefix}}/etc/php-fpm.d/www.conf
        - source: salt://common/config/php-fpm/www.conf
        - mode: 644
        - user: root
        - group: root
        - require:
          - cmd: php-installed
        - template: jinja
        - defaults:
          php_log: {{logdir}}


php-pear:
    file.managed:
        - name: {{prefix}}/etc/pear.conf
        - source: salt://common/config/php-fpm/pear.conf
        - mode: 644
        - user: root
        - group: root
        - require:
          - cmd: php-installed

# default ini files
php-ini:
    file.managed:
        - name: {{prefix}}/lib/php.ini
        - source: salt://common/config/php-fpm/php.ini
        - mode: 644
        - user: root
        - group: root
        - require:
          - cmd: php-installed

php-running:
    file.managed:
        - name: /etc/supervisord.conf.d/php-fpm.conf
        - source: salt://common/supervisor/example.conf
        - require:
          - file: php-ini
          - file: php-installed
          - file: php-www
        - defaults:
          event_call: php
          event_cmd: {{prefix}}/sbin/php-fpm --fpm-config {{prefix}}/etc/php-fpm.conf
          event_dir: {{prefix}}
          event_sign: QUIT
          event_user: root
        - template: jinja
    cmd.run:
        - name: supervisorctl update && sleep 3 && supervisorctl status php-fpm
        - unless: supervisorctl restart php-fpm
        - require:
          - file: php-running
        - watch:
          - file: php-running

