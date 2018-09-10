sshd_config:
    file.managed:
        - name : /etc/ssh/sshd_config
        - source : salt://common/config/sshd/sshd_config
        - template: jinja

sshd_restar:
    cmd.run:
        - name: systemctl restart sshd
