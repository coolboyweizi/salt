liumin:
    user.present:
        - shell: /bin/bash
        - home: /home/liumin
        - gid: 100
        - uid: 1008
        - password: $1$0LbXOaMc$teHibB9UIKmyWKi3jFCPz/

liumin-ssh:
    file.directory:
        - name: /home/liumin/.ssh
        - mkdirs: true
        - user: liumin
        - group: users
        - dir_mode: 700
        #- require:
        #  - user: liumin

liumin-sudoers.d:
    file.managed:
        - name: /etc/sudoers.d/liumin
        - source: salt://common/config/user/visudoliumin
        - mode: 440


liumin-authorized_keys:
    file.managed:
        - name: /home/liumin/.ssh/authorized_keys
        - source: salt://common/config/user/liumin
        - user: liumin
        - group: users
        - mode: 600
        #- require:
        #  - file: liumin-ssh
liumin-vimrc:
    file.managed:
        - name: /home/liumin/.vimrc
        - source: salt://common/config/vim/vimrc
        - mode: 644
        - users: liumin
        - groups: users
        #- require:
         # - user: liumin



