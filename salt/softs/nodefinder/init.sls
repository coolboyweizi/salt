nodefinder:
    cmd.run:
        - name: /usr/bin/env php -v

    archive.extracted:
        - name: /usr/local/
        - source: salt://common/packages/consistent-hasher.tar.bz2
        - user: nobody
        - group: nobody
        - require:
          - cmd: nodefinder

    file.symlink:
        - name: /usr/bin/NodeFinder
        - target: /usr/local/consistent-hasher/NodeFinder
        - require:
          - archive: nodefinder



