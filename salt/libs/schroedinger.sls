# nettle libs for ffmpeg

schroedinger-intall:
    archive.extracted:
      - source: salt://packages/schroedinger-1.0.11.tar.gz
      - name: /data/soft

    cmd.run:
      - name: ./configure --prefix=/usr --libdir=/usr/lib64 && make -j2 && make -j2 install
      - cwd: /data/soft/schroedinger-1.0.11
      - unless: test -f /usr/lib64/libschroedinger-1.0.so
