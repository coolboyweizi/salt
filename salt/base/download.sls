{% set root = "/srv/salt/base/common/packages" %}
{% set repo = "http://18.197.185.247/soft"%}
prepare:
    file.directory:
      - name: {{root}}
      - user: root
      - mode: 755
      - group: root
      - makedirs: true

appdirs:
    file.managed:
      - name: {{root}}/appdirs-1.4.3.tar.gz
      - source: https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz
      - source_hash: 9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92

six:
    file.managed:
      - name: {{root}}/six-1.10.0.tar.gz
      - source: https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz
      - source_hash: 105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a

packaging:
    file.managed:
      - name: {{root}}/packaging-16.8.tar.gz
      - source: https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz
      - source_hash: 5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e


jdk:
    file.managed:
      - name: {{root}}/jdk1.8.0_162.tar.gz
      - source_hash: 781e3779f0c134fb548bde8b8e715e90
      - source: {{repo}}/jdk1.8.0_162.tar.gz

python3:
    file.managed:
      - name: {{root}}/Python-3.6.1.tar.xz
      - source: https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz
      - source_hash: 692b4fc3a2ba0d54d1495d4ead5b0b5c

pyparsing:
    file.managed:
      - name: {{root}}/pyparsing-2.2.0.tar.gz
      - source: https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz
      - source_hash: 0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04

pip:
    file.managed:
      - name: {{root}}/pip-9.0.1.tar.gz
      - source: https://files.pythonhosted.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz
      - source_hash: 09f243e1a7b461f654c26a725fa373211bb7ff17a9300058b205c61658ca940d

setuptools:
    file.managed:
      - name: {{root}}/setuptools-34.3.3.zip
      - source: https://files.pythonhosted.org/packages/d5/b7/e52b7dccd3f91eec858309dcd931c1387bf70b6d458c86a9bfcb50134fbd/setuptools-34.3.3.zip
      - source_hash: 2cd244d3fca6ff7d0794a9186d1d19a48453e9813ae1d783edbfb8c348cde905

zabbix:
  file.managed:
    - name: {{root}}/zabbix-3.2.1.tar.gz
    - source: https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.2.1/zabbix-3.2.1.tar.gz/download
    - source_hash: 4f363b923ef2b5eefddee8dfc5f51e2b
