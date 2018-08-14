log_dir:
    file.directory:
        - name: /data/log
        - makedirs: true
        - user: root
        - group: root
        - dir_mode: 755
soft_dir:
    file.directory:
        - name: /data/soft
        - makedirs: true
        - user: root
        - group: root
        - dir_mode: 755


apk_install:
    pkg.installed:
        - names:
          - unzip
          - gcc
          - gcc-c++
          - wget
          - cmake
          - make
          - tmux
          - vim-enhanced
          - traceroute
          - libcurl-devel
          - bzip2
          - iotop
          - telnet
          - psmisc
          - net-tools
          - bind-utils
          - binutils
          - lsof
          - git
          - openssl-devel
          - lrzsz
          - ntpdate
          - python-devel
          - jq

