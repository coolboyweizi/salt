php-pkg:
    pkg.installed:
      - names:
        - glibc-devel
        - libxml2-devel
        - libxslt-devel
        - openssl-devel
        - zlib-devel
        - bzip2-devel
        - libcurl-devel
        - gdbm-devel
        - gd-devel
        - libvpx-devel
        - libpng-devel
        - libXpm-devel
        - libjpeg-turbo-devel
        - freetype-devel
        - gettext-devel
        - gmp-devel
        - libedit-devel
        - readline-devel
        - libicu-devel
        - ncurses-devel
        - readline-devel
        - bzip2-devel

# mhash install to /usr/local/lib
php-pkg-mhash:
    archive.extracted:
        - name: /data/soft/
        - source: salt://common/packages/mhash-0.9.9.9.tar.gz
        - user: root
        - group: root

    cmd.run:
        - name: ./configure && make && make install
        - unless: test -f /usr/local/lib/libmhash.so
        - cwd: /data/soft/mhash-0.9.9.9
        - require:
          - archive: php-pkg-mhash
    file.symlink:
        - name: /usr/local/lib64/libmhash.so.2
        - target: /usr/local/lib/libmhash.so.2
        - force: true

# libmcrypt
php-pkg-libmcrypt:
    archive.extracted:
        - name: /data/soft/
        - source: salt://common/packages/libmcrypt-2.5.8.tar.gz
        - user: root
        - group: root

    cmd.run:
        - name: ./configure && make && make install
        - unless: test -f /usr/local/lib/libmcrypt.so
        - cwd: /data/soft/libmcrypt-2.5.8
        - require:
          - archive: php-pkg-libmcrypt
    file.symlink:
        - name: /usr/local/lib64/libmcrypt.so.4
        - target: /usr/local/lib/libmcrypt.so.4
        - force: true

php-pkg-tidy:
    archive.extracted:
        - name: /data/soft/
        - source: salt://common/packages/tidy-html5-5.6.0.tar.gz
        - user: root
        - group: root
    cmd.run:
        - name: cmake ../.. -DCMAKE_BUILD_TYPE=Release && make && make install
        - unless: test -f /usr/local/lib/libtidy.so
        - cwd: /data/soft/tidy-html5-5.6.0/build/cmake
        - require:
          - archive: php-pkg-tidy
    file.symlink:
        - name:  /usr/local/lib64/libtidy.so.5
        - target: /usr/local/lib/libtidy.so.5
        - force: true


