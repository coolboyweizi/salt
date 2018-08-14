gao-cms-server.management.sing.plus:
  mu-cms: primary
  group: cms-sing-plus
  section: primary
  nginxT: True
  celery:
      - python_celery_beat.conf
      - python_celery_cam.conf
      - python_celery_d.conf
      - python_celery_d1.conf
      - python_celery_d2.conf
      - python_celery_d3.conf
      - python_celery_d4.conf
      - python_celery_d5.conf









