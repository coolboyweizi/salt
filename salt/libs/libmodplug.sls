# nettle libs for ffmpeg

modplug-intall:
    archive.extracted:
      - source: salt://packages/libmodplug-0.8.9.0.tar.gz
      - name: /data/soft

    cmd.run:
      - name: ./configure --prefix=/usr --libdir=/usr/lib64 && make -j2 && make -j2 install
      - cwd: /data/soft/libmodplug-0.8.9.0
      - unless: test -f /usr/lib64/libmodplug.so

