wangwei:
    user.present:
        - shell: /bin/bash
        - home: /home/wangwei
        - gid: 100
        - uid: 1003
        - password: $1$gmTHOy3M$EdtZ4enyFH65a9NOAWihi1

wangwei-ssh:
    file.directory:
        - name: /home/wangwei/.ssh
        - mkdirs: true
        - user: wangwei
        - group: users
        - dir_mode: 700
        #- require:
        #  - user: wangwei

wangwei-sudoers.d:
    file.managed:
        - name: /etc/sudoers.d/wangwei
        - source: salt://common/config/user/visudowang
        - mode: 440


wangwei-authorized_keys:
    file.managed:
        - name: /home/wangwei/.ssh/authorized_keys
        - source: salt://common/config/user/wangwei
        - user: wangwei
        - group: users
        - mode: 600
        #- require:
        #  - file: wangwei-ssh
wangwei-vimrc:
    file.managed:
        - name: /home/wangwei/.vimrc
        - source: salt://common/config/vim/vimrc
        - mode: 644
        - users: wangwei
        - groups: users
        #- require:
         # - user: wangwei



