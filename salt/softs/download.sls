#percona
{% set root = "/srv/salt/softs/common/packages" %}
{% set repo = "http://18.197.185.247/soft" %}


prepare:
    file.directory:
      - name: {{root}}
      - user: root
      - mode: 755
      - group: root
      - makedirs: true

percona:
  file.managed:
    - name: {{root}}/Percona-Server-5.7.17-13-Linux.x86_64.ssl101.tar.gz
    - source: https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-5.7.17-13/binary/tarball/Percona-Server-5.7.17-13-Linux.x86_64.ssl101.tar.gz
    - source_hash: https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-5.7.17-13/binary/tarball/Percona-Server-5.7.17-13-Linux.x86_64.ssl101.tar.gz.md5sum
    - user: root
    - group: root

boost_1_59_0:
  file.managed:
    - name: {{root}}/boost_1_59_0.tar.gz
    - source: https://jaist.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
    - source_hash: 51528a0e3b33d9e10aaa311d9eb451e3

elastic:
  file.managed:
    - name:  {{root}}/elasticsearch-5.5.0.zip
    - source: https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.0.zip
    - source_hash: https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.0.zip.sha1



mongodb:
  file.managed:
    - name: {{root}}/mongodb-linux-x86_64-rhel70-3.4.4.tgz
    - source: http://downloads.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.4.tgz?_ga=2.219527385.131635341.1523590428-1279714845.1522233301
    - source_hash: http://downloads.mongodb.org/linux/mongodb-linux-x86_64-rhel70-3.4.4.tgz.md5?_ga=2.241678530.131635341.1523590428-1279714845.1522233301


kibana:
  file.managed:
    - name: {{root}}/kibana-5.5.0-linux-x86_64.tar.gz
    - source: https://artifacts.elastic.co/downloads/kibana/kibana-5.5.0-linux-x86_64.tar.gz
    - source_hash: https://artifacts.elastic.co/downloads/kibana/kibana-5.5.0-linux-x86_64.tar.gz.sha1

php:
  file.managed:
    - name: {{root}}/php-7.1.3.tar.gz
    - source: http://am1.php.net/distributions/php-7.1.3.tar.gz
    - source_hash: sha256=4bfadd0012b966eced448497272150ffeede13136a961aacb9e71553b8e929ec

ffpmeg:
  file.managed:
    - name: {{root}}/ffmpeg-3.3.1.tar.bz2
    - source: http://ffmpeg.org/releases/ffmpeg-3.3.1.tar.bz2
    - source_hash: eb3fff329cd7e72cf8c3b309dbbe1f9c

openssl:
  file.managed:
    - name: {{root}}/openssl-1.0.2k.tar.gz
    - source: https://www.openssl.org/source/openssl-1.0.2k.tar.gz
    - source_hash: 6b3977c61f2aedf0f96367dcfb5c6e578cf37e7b8d913b4ecb6643c3cb88d8c0


zookeeper:
  file.managed:
    - name: {{root}}/zookeeper-3.4.10.tar.gz
    - source: http://www-eu.apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz
    - source_hash: http://www-eu.apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz.sha1


kafka:
  file.managed:
    - name: {{root}}/kafka_2.12-1.0.1.tgz
    - source_hash: d61a5e04d584ed6dea6f63db555b9782
    - source: http://www-eu.apache.org/dist/kafka/1.0.1/kafka_2.12-1.0.1.tgz


openresty:
  file.managed:
    - name: {{root}}/openresty-1.11.2.3.tar.gz
    - source: https://openresty.org/download/openresty-1.11.2.3.tar.gz
    - source_hash: f9ec79ecbb4a2c84f21d21ab743afac2


beanstalkd:
  file.managed:
    - name: {{root}}/beanstalkd-1.10.tar.gz
    - source_hash: 0994d83b03bde8264a555ea63eed7524
    - source: {{repo}}/beanstalkd-1.10.tar.gz

certbot:
  file.managed:
    - name: {{root}}/certbot-master.zip
    - source_hash: 917cba4f2bedcb82075333ed3bc85691
    - source: {{repo}}/certbot-master.zip

consistent-hasher:
  file.managed:
    - name: {{root}}/consistent-hasher.tar.bz2
    - source: {{repo}}/consistent-hasher.tar.bz2
    - source_hash: 4111032b08b91dc51dc39c3fdf1b7d63

geoIP:
  file.managed:
    - name: {{root}}/GeoIP.tar.gz
    - source: {{repo}}/GeoIP.tar.gz
    - source_hash: 05b7300435336231b556df5ab36f326d

letsencrypt:
  file.managed:
    - name: {{root}}/letsencrypt.tar.gz
    - source: {{repo}}/letsencrypt.tar.gz
    - source_hash: 1310ff0e9b510a716b6b22a1c8c2f17e

letsencrypt-shell:
  file.managed:
    - name: {{root}}/letsencrypt-shell
    - source: {{repo}}/letsencrypt-shell
    - source_hash: a53ae2caa0ded2c4a3a872abfed0f63c

libmcrypt:
  file.managed:
    - name: {{root}}/libmcrypt-2.5.8.tar.gz
    - source: {{repo}}/libmcrypt-2.5.8.tar.gz
    - source_hash: 0821830d930a86a5c69110837c55b7da

libzip-0.11.2.tar:
  file.managed:
    - name: {{root}}/libzip-0.11.2.tar
    - source: {{repo}}/libzip-0.11.2.tar
    - source_hash: 08bb80816830ce49c95855c08dd572b0

mhash:
  file.managed:
    - name: {{root}}/mhash-0.9.9.9.tar.gz
    - source: {{repo}}/mhash-0.9.9.9.tar.gz
    - source_hash: ee66b7d5947deb760aeff3f028e27d25

redis:
  file.managed:
    - name: {{root}}/redis-3.2.8.tar.gz
    - source: {{repo}}/redis-3.2.8.tar.gz
    - source_hash: c91867a18ae0c5f7bb61a7c1120d80b4

tidy:
  file.managed:
    - name: {{root}}/tidy-html5-5.6.0.tar.gz
    - source: {{repo}}/tidy-html5-5.6.0.tar.gz
    - source_hash: 85c8a163d9ece6a02fe12bc9bddbc455


xtrabackup:
  file.managed:
    - name: {{root}}/percona-xtrabackup-2.4.10-Linux-x86_64.libgcrypt11.tar.gz
    - source: https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.10/binary/tarball/percona-xtrabackup-2.4.10-Linux-x86_64.libgcrypt11.tar.gz
    - source_hash: https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.10/binary/tarball/percona-xtrabackup-2.4.10-Linux-x86_64.libgcrypt11.tar.gz.md5sum


nodejs:
  file.managed:
    - name: {{root}}/node-v9.11.1.tar.gz
    - source: https://nodejs.org/dist/v9.11.1/node-v9.11.1.tar.gz
    - source_hash: 62cc091b00e4f29e110e59c7f41645144c89eb513e250a96f96df2c3f74f50ee