# nettle libs for ffmpeg

soxr-intall:
    archive.extracted:
      - source: salt://packages/soxr-0.1.2-Source.tar.xz
      - name: /data/soft

    cmd.run:
      - name: cmake -DCMAKE_INSTALL_PREFIX=/usr && make && make install
      - unless: test -f /usr/lib/libsoxr.so
      - cwd: /data/soft/soxr-0.1.2-Source

