# nettle libs for ffmpeg

SDL2-intall:
    pkg.installed:
        - names:
          - libXext-devel

    archive.extracted:
      - source: salt://packages/SDL2-2.0.8.zip
      - name: /data/soft
      - use_cmd_unzip: True

    cmd.run:
      - name: ./configure --prefix=/usr --libdir=/usr/lib64 && make -j2 && make -j2 install
      - unless: test -f /usr/lib64/libSDL2.so
      - cwd: /data/soft/SDL2-2.0.8

