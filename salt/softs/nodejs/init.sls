nodejs-install:

  archive.extracted:
    - name: /data/soft
    - source: salt://common/packages/node-v9.11.1.tar.gz

  cmd.run:
    - name: ./configure --prefix=/usr/local/node-v9.11.1 && make && make install
    - unless: which node
    - cwd: /data/soft/node-v9.11.1

  file.symlink:
    - name: /usr/bin/node
    - target: /usr/local/node-v9.11.1/bin/node
    - force: True


nodejs-pm2:


  cmd.run:
    - name: /usr/local/node-v9.11.1/bin/npm install pm2 -g
    - cwd: /usr/local/node-v9.11.1
    - unless: which pm2

  file.symlink:
    - name: /usr/bin/pm2
    - target: /usr/local/node-v9.11.1/lib/node_modules/pm2/bin/pm2
    - force: True