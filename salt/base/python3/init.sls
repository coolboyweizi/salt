# python3 环境的安装


python3-packages:
  file.managed:
    - name : /data/soft/Python-3.6.1.tar.xz
    - source: salt://common/packages/Python-3.6.1.tar.xz


  cmd.run:
    - name : test -f Python-3.6.1.tar
    - unless: xz -d Python-3.6.1.tar.xz && tar xvf Python-3.6.1.tar
    - cwd: /data/soft/
    - require:
      - file: python3-packages


python3-build:
  cmd.run:
    - name: test -x /usr/local/python-3.6.1/bin/python3
    - unless: ./configure --prefix=/usr/local/python-3.6.1 --enable-loadable-sqlite-extensions && make -j2 && make -j2 install
    - cwd: /data/soft/Python-3.6.1
    - require:
      - cmd: python3-packages

python3-env:
  cmd.run:
    - name : test -L /usr/bin/python3
    - unless:  ln -s  /usr/local/python-3.6.1/bin/python3 /usr/bin/python3
    - require:
        - cmd: python3-build


python3-uwsgi:
  cmd.run:
    - name: /usr/local/python-3.6.1/bin/pip3 install uwsgi
    - require:
        - cmd: python3-build