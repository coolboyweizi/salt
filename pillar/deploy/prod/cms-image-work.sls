aws-worker-server.management.sing.plus:
  fr-aws: primary
  env: fr-aws
  group: cms-sing-plus
  section: primary
  nginxT: True
  celery:
      - python_celery_beat.conf
      - python_celery_cam.conf
      - python_celery_d.conf





