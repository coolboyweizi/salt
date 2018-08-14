get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - require:
      - cmd: php-symlink

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/bin/composer
    - cwd: /root/
    - watch:
      - cmd: get-composer

