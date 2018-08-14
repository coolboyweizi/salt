# nettle libs for ffmpeg

gnutls-intall:
    archive.extracted:
      - source: salt://packages/gnutls-3.3.26.tar.xz
      - name: /data/soft

    cmd.run:
      - name: ./configure --prefix=/usr && make -j2 && make -install
      - cwd: /data/soft/gnutls-3.3.26
      - unless: test -f /usr/lib64/libgnutls.so
