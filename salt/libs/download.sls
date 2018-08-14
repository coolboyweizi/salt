{% set root = "/srv/salt/libs/packages" %}
{% set repo = "http://18.197.185.247/soft" %}

prepare:
    file.directory:
      - name: {{root}}
      - user: root
      - mode: 755
      - group: root
      - makedirs: true


gnutls:
  file.managed:
    - name: {{root}}/gnutls-3.3.26.tar.xz
    - source: {{repo}}/gnutls-3.3.26.tar.xz
    - source_hash: 9840c06019bfa7db07ed8fd5e63106d5

lame:
  file.managed:
    - name: {{root}}/lame-3.100.tar.gz
    - source: {{repo}}/lame-3.100.tar.gz
    - source_hash: 83e260acbe4389b54fe08e0bdbf7cddb

libass:
  file.managed:
    - name: {{root}}/libass-0.14.0.tar.xz
    - source: {{repo}}/libass-0.14.0.tar.xz
    - source_hash: 5b8c23340654587b8a472cb74ee9366b

libmodplug:
  file.managed:
    - name: {{root}}/libmodplug-0.8.9.0.tar.gz
    - source: {{repo}}/libmodplug-0.8.9.0.tar.gz
    - source_hash: 5ba16981e6515975e9a68a58d5ba69d1


nettle:
  file.managed:
    - name: {{root}}/nettle-2.7.1.tar.gz
    - source: {{repo}}/nettle-2.7.1.tar.gz
    - source_hash: 05a6f084fc29a2da9d8fa4cc5ec6fa2b

schroedinger:
  file.managed:
    - name: {{root}}/schroedinger-1.0.11.tar.gz
    - source: {{repo}}/schroedinger-1.0.11.tar.gz
    - source_hash: da6af08e564ca1157348fb8d92efc891

sdl2:
  file.managed:
    - name: {{root}}/SDL2-2.0.8.zip
    - source: {{repo}}/SDL2-2.0.8.zip
    - source_hash: ad40c4872a96af519f6e5be698ed6093

soxr:
  file.managed:
    - name: {{root}}/soxr-0.1.2-Source.tar.xz
    - source: {{repo}}/soxr-0.1.2-Source.tar.xz
    - source_hash: 0866fc4320e26f47152798ac000de1c0

yasm:
  file.managed:
    - name: {{root}}/yasm-1.2.0.tar.gz
    - source: {{repo}}/yasm-1.2.0.tar.gz
    - source_hash: 4cfc0686cf5350dd1305c4d905eb55a6