leikou:
    user.present:
        - shell: /bin/bash
        - home: /home/leikou
        - gid: 100
        - uid: 1001
        - password: $1$hFquSTf5$PU6sTg8R9wG5IbGK4PAFU1

leikou-ssh:
    file.directory:
        - name: /home/leikou/.ssh
        - mkdirs: true
        - user: leikou
        - group: users
        - dir_mode: 700
        #- require:
        #  - user: leikou


leikou-sudoers.d:
    file.managed:
        - name: /etc/sudoers.d/leikou
        - source: salt://common/config/user/visudolei
        - mode: 440




leikou-authorized_keys:
    file.managed:
        - name: /home/leikou/.ssh/authorized_keys
        - source: salt://common/config/user/leikou
        - user: leikou
        - group: users
        - mode: 600
        #- require:
        #  - file: leikou-ssh

leikou-vimrc:
    file.managed:
        - name: /home/leikou/.vimrc
        - source: salt://common/config/vim/vimrc
        - mode: 644
        - users: leikou
        - groups: users
        #- require:
        #  - user: leikou



