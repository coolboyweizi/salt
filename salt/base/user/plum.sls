plum:
    user.present:
        - shell: /bin/bash
        - home: /home/plum
        - gid: 100
        - uid: 1002
        - password: $1$7UNNbSQR$ZWypumEa0ir5RCTnklXCB.

plum-ssh:
    file.directory:
        - name: /home/plum/.ssh
        - mkdirs: true
        - user: plum
        - group: users
        - dir_mode: 700
        - require:
          - user: plum

plum-sudoers.d:
    file.managed:
        - name: /etc/sudoers.d/plum
        - source: salt://common/config/user/visudoplum
        - mode: 440


plum-authorized_keys:
    file.managed:
        - name: /home/plum/.ssh/authorized_keys
        - source: salt://common/config/user/plum
        - user: plum
        - group: users
        - mode: 600
        #- require:
        #  - file: plum-ssh
plum-vimrc:
    file.managed:
        - name: /home/plum/.vimrc
        - source: salt://common/config/vim/vimrc
        - mode: 644
        - users: plum
        - groups: users
        #- require:
        #  - user: plum



