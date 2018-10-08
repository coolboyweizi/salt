tianxiaotong:
    user.present:
        - shell: /bin/bash
        - home: /home/tianxiaotong
        - gid: 100
        - uid: 1007
        - password: $1$cWNRujBS$EYDnxv4PGayrys7aK0w120

tianxiaotong-ssh:
    file.directory:
        - name: /home/tianxiaotong/.ssh
        - mkdirs: true
        - user: tianxiaotong
        - group: users
        - dir_mode: 700
        #- require:
        #  - user: tianxiaotong

tianxiaotong-sudoers.d:
    file.managed:
        - name: /etc/sudoers.d/tianxiaotong
        - source: salt://common/config/user/visudotian
        - mode: 440


tianxiaotong-authorized_keys:
    file.managed:
        - name: /home/tianxiaotong/.ssh/authorized_keys
        - source: salt://common/config/user/tian
        - user: tianxiaotong
        - group: users
        - mode: 600
        #- require:
        #  - file: tianxiaotong-ssh
tianxiaotong-vimrc:
    file.managed:
        - name: /home/tianxiaotong/.vimrc
        - source: salt://common/config/vim/vimrc
        - mode: 644
        - users: tianxiaotong
        - groups: users
        #- require:
         # - user: tianxiaotong



