vim_rc:
    file.managed:
        - name: /root/.vimrc
        - source: salt://common/config/vim/vimrc
        - user: root
        - group: root
        - mode: 644

vim_color:
    file.managed:
        - name: /usr/share/vim/vim74/colors/molokai.vim
        - source: salt://common/config/vim/molokai.vim
        - user: root
        - group: root
        - mode: 644

vim_pkg:
    pkg.installed:
        - names:
            - vim
        - unless: rpm -qa | grep vim


inputrc:
    file.managed:
        - name: /root/.inputrc
        - source: salt://common/config/vim/inputrc
        - user: root
        - group: root
        - mode: 644
