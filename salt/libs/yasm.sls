# yasm libs for ffmpeg

yasm-intall:
    archive.extracted:
      - source: salt://packages/yasm-1.2.0.tar.gz
      - name: /data/soft

    cmd.run:
      - name: ./configure --prefix=/usr && make -j2 && make install
      - unless: test -f /usr/lib/libyasm.a
      - cwd: /data/soft/yasm-1.2.0

