
ffmpeg-install:
    pkg.installed:
        - names:
            - libbluray-devel
            - openjpeg-devel
            - speex-devel
            - libtheora-devel
            - libvorbis-devel
            - gnutls-devel
            - libvpx-devel

    archive.extracted:
        - name: /data/soft
        - source: salt://common/packages/ffmpeg-3.3.1.tar.bz2

    cmd.run:
       - name: ./configure --prefix=/usr --enable-swscale --enable-avfilter --enable-avresample --enable-avformat --enable-libmp3lame --enable-libvorbis --enable-libtheora --enable-libschroedinger --enable-libopenjpeg --enable-libmodplug --enable-libvpx --enable-libsoxr --enable-libspeex --enable-libass --enable-libbluray --enable-lzma --enable-gnutls --enable-fontconfig --enable-libfreetype --enable-libfribidi --disable-libxcb --disable-libxcb-shm --disable-libxcb-xfixes --disable-indev=jack --disable-outdev=xv --enable-sdl2 --enable-shared --enable-pthreads --enable-videotoolbox --enable-yasm --enable-gpl --enable-postproc && make -j2 && make -j2 install
       - cwd: /data/soft/ffmpeg-3.3.1
       - unless: ffmpeg -version
       - require:
          - archive: ffmpeg-install

ffmpeg-finish:
    cmd.run:
      - name: ldconfig && ffmpeg -version
      - require:
        - cmd: ffmpeg-install