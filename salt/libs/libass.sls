# nettle libs for ffmpeg

libass-pkg:
    pkg.installed:
      - names:
        - fribidi-devel

libass-intall:
    archive.extracted:
      - source: salt://packages/libass-0.14.0.tar.xz
      - name: /data/soft

    cmd.run:
      - name: ./configure --prefix=/usr --libdir=/usr/lib64 && make -j2 && make install
      - cwd: /data/soft/libass-0.14.0
      - unless: /usr/lib64/libass.so


