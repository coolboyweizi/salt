# nettle libs for ffmpeg

nettle-install:
    archive.extracted:
      - source: salt://packages/nettle-2.7.1.tar.gz
      - name: /data/soft

    cmd.run:
      - name: ./configure --prefix=/usr && make -j2 && make -install
      - cwd: /data/soft/nettle-2.7.1
      - unless: test -f /usr/lib64/libnettle.so
