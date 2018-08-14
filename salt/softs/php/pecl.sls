{% set prefix  =  "/usr/local/php-7.1.3" %}

php_ext_redis:
    cmd.run:
        - name: pecl list | grep redis
        - unless: pecl install redis-3.1.4
        - require:
          - file: php-ini
          - cmd:  php-symlink

    file.append:
        - name: {{prefix}}/lib/php.ini
        - text: extension=redis.so
        - require:
          - cmd: php_ext_redis


php_ext_mongodb:
    cmd.run:
        - name: pecl list | grep mongodb
        - unless: pecl install mongodb-1.3.4
        - require:
          - file: php-ini
          - cmd:  php-symlink

    file.append:
        - name: {{prefix}}/lib/php.ini
        - text: extension=mongodb.so
        - require:
          - cmd: php_ext_mongodb


php_ext_zip:
    archive.extracted:
      - name: /data/soft/
      - source: salt://common/packages/libzip-0.11.2.tar
      - require:
          - file: php-ini
          - cmd:  php-symlink

    cmd.run:
      - name: test -f /usr/local/include/zip.h
      - unless: ./configure && make && make install && ln -s /usr/local/lib/libzip/include/zipconf.h /usr/local/include/
      - cwd: /data/soft/libzip-0.11.2
      - require:
          - archive: php_ext_zip

php_ext_zip_install:
    cmd.run:
      - name: pecl list | grep zip
      - unless: pecl install zip-1.15.1
      - require:
          - cmd: php_ext_zip

    file.append:
        - name: {{prefix}}/lib/php.ini
        - text: extension=zip.so
        - require:
          - cmd: php_ext_zip_install
