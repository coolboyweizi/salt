kateson:
    user.present:
        - shell: /bin/bash
        - home: /home/kateson
        - gid: 100
        - uid: 1008
        - password: $1$SIpHYluR$c/yW1tN.pgOC7cY9kPWBo1

kateson-ssh:
    file.directory:
        - name: /home/kateson/.ssh
        - mkdirs: true
        - user: kateson
        - group: users
        - dir_mode: 700
        #- require:
        #  - user: kateson


kateson-sudoers.d:
    file.managed:
        - name: /etc/sudoers.d/kateson
        - source: salt://common/config/user/visudokate
        - mode: 440




kateson-authorized_keys:
    file.managed:
        - name: /home/kateson/.ssh/authorized_keys
        - source: salt://common/config/user/kateson
        - user: kateson
        - group: users
        - mode: 600
        #- require:
        #  - file: kateson-ssh

kateson-vimrc:
    file.managed:
        - name: /home/kateson/.vimrc
        - source: salt://common/config/vim/vimrc
        - mode: 644
        - users: kateson
        - groups: users
        #- require:
        #  - user: kateson



