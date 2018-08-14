go-agent-prepare:
    group.present:
        - name: go
        - gid: 930
        - system: True

    user.present:
        - name: go
        - gid: 930
        - uid: 930
        - shell: /bin/bash
        - home: /var/go
        - require:
            - group: go-agent-prepare

    archive.extracted:
        - name: /var/go
        - source: salt://gocd/ssh.tar.bz2
        - user: go
        - group: go

    file.directory:
        - name: /data/go_agent_workspace/go-agent
        - user: go
        - group: go
        - makedirs: true
        - require:
          - user: go-agent-prepare


go-agent-install:
    pkgrepo.managed:
        - name: gocd
        - baseurl: https://download.gocd.io
        - enabled: 1
        - gpgcheck: 1
        - gpgkey: https://download.gocd.io/GOCD-GPG-KEY.asc

    pkg.installed:
        - name: go-agent
        - require:
          - pkgrepo: go-agent-install

    file.managed:
        - name: /etc/default/go-agent
        - source: salt://common/config/go-agent
        - user: go
        - group: go
        - mode: 640
        - require:
          - pkg: go-agent-install

    service.running:
        - name: go-agent
        - enable: True
        - reload: True
        - watch:
          - file: /etc/default/go-agent

