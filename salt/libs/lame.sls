# nettle libs for ffmpeg

lame-pkg:
    pkg.installed:
        - names:
            - orc-devel

lame-intall:
    archive.extracted:
      - source: salt://packages/lame-3.100.tar.gz
      - name: /data/soft

    cmd.run:
      - name: ./configure --prefix=/usr --libdir=/usr/lib64 && make -j2 && make -j2 install
      - cwd: /data/soft/lame-3.100

