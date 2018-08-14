certbot-work:
  file.directory:
    - name: /data/www/_challenges-5817040be49bd

certbot-packages:
  archive.extracted:
    - name: /data/soft/
    - source: salt://common/packages/certbot-master.zip
    - use_cmd_unzip: True
    - user: root
    - group: root

  file.copy:
        - name: /usr/local/certbot-master
        - source: /data/soft/certbot-master
        - user: root
        - group: root
        - require:
            - archive: certbot-packages

  cmd.run:
    - name: test -L /usr/bin/letsencrypt-auto
    - unless: ln -s /usr/local/certbot-master/letsencrypt-auto /usr/bin/
    - require:
      - file: certbot-packages

certbot-shell:
  cmd.run:
    - name: pip install virtualenv
    - unless: pip list | grep virtualenv

  file.managed:
    - name: /usr/bin/letsencrypt-shell
    - source: salt://common/packages/letsencrypt-shell
    - mode: 755
    - require:
      - cmd: certbot-packages

  archive.extracted:
    - name: /etc
    - source: salt://common/packages/letsencrypt.tar.gz