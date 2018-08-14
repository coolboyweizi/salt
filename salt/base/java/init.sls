{% set version = "jdk1.8.0_162" %}

java-package:
    archive.extracted:
        - name: /data/soft
        - source: salt://common/packages/{{version}}.tar.gz

    file.copy:
        - name: /usr/local/{{version}}
        - source: /data/soft/{{version}}
        - force: false
        - require:
          - archive: java-package


java-validate:
    file.symlink:
        - name: /usr/bin/java
        - target: /usr/local/{{version}}/bin/java
        - force: true
        - backupname: java.old
        - require:
          - file: java-package

    cmd.run:
        - name: java -version
        - require:
          - file: java-validate


