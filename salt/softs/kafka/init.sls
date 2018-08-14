kafka-prepare:
    file.directory:
      - name: /data/kafka/kafka-logs
      - makedirs: true
      - user: root
      - group: root


kafka-install:
    archive.extracted:
      - name: /opt
      - source: salt://common/packages/kafka_2.12-1.0.1.tgz
      - user: root
      - grup: root
    file.managed:
      - name: /opt/kafka_2.12-1.0.1/config/server.properties
      - source: salt://common/config/kafka.conf
      - user: root
      - group: root

kafka-run:

    file.managed:
      - name: /etc/supervisord.conf.d/kafka.conf
      - source: salt://common/supervisor/example.conf
      - template: jinja
      - defaults:
        event_call: kafka
        event_cmd: /opt/kafka_2.12-1.0.1/bin/kafka-server-start.sh config/server.properties
        event_dir: /opt/kafka_2.12-1.0.1
        event_sign: TERM
        event_user: root

    cmd.run:
      - name: supervisorctl restart kafka
      - unless: supervisorctl update kafka
      - require:
        - file: kafka-run




