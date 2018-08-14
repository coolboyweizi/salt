zookeeper-prepare:
    file.directory:
      - name: /data/zookeeper

zookeeper-install:
    archive.extracted:
      - name: /opt
      - source: salt://common/packages/zookeeper-3.4.10.tar.gz

    file.managed:
      - name: /opt/zookeeper-3.4.10/conf/zoo.cfg
      - source: salt://common/config/zookeeper.conf

zookeeper-run:
    cmd.run:
      - name: /opt/zookeeper-3.4.10/bin/zkServer.sh restart
      - runas: root
      - require:
        - file: zookeeper-prepare
        - file: zookeeper-install




