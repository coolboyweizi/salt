host-managed:
    file.managed:
      - name: /etc/hosts
      - mode: 644
      - user: root
      - group: root
      - source: salt://hosts/files/hosts
