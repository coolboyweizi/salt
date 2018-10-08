base:
  'dashboard':
    - frankfurt

  'fr-*':
    - frankfurt

  'mu-*':
    - mumbai

deploy:

  'dashboard':
      - glob
      - staging.api-sing-plus-secondary

  'fr-staging':
      - glob
      - staging.api-sing-plus-primary
      - staging.boom-sing-plus-primary
      - staging.im-sing-plus
      - staging.search-sing-plus
      - staging.answer-sing-plus
      - staging.cms-sing-plus


  'fr-app':
      - glob
      - prod.api-sing-plus-primary
      - prod.boom-sing-plus-primary

  'fr-app-s1':
      - glob
      - prod.api-sing-plus-secondary
      - prod.boom-sing-plus-secondary

  'fr-cms':
      - glob
      - prod.cms-sing-plus

  'fr-cms-s1':
      - glob
      - prod.cms-sing-work-plus

  'fr-elastic':
      - glob
      - prod.im-sing-plus-primary
      - prod.answer-sing-plus-primary
      - prod.search-sing-plus
      - prod.www-sing-plus-primary

  'fr-imgrizer':
      - glob
      - prod.cms-image-work

  'mu-app':
      - glob
      - prod.api-gao-sing-plus-primary

  'mu-app-s1':
      - glob
      - prod.api-gao-sing-plus-secondary
      - prod.search-gao-sing-plus
      - prod.im-gao-primary
      - prod.gao-sing-plus-primary

  'mu-staging':
      - glob
      - staging.api-gao-sing-plus-primary
      - staging.im-gao-primary
      - staging.search-gao-sing-plus
      - staging.gao-sing-plus-primary
      - staging.gao-cms-sing-plus

  'mu-cms':
      - glob
      - prod.gao-cms-sing-plus

  'mu-cms-s1':
      - glob
      - prod.gao-cms-sing-work-plus

softs:
  '*':
      - service-api
  'fr-db-s1':
      - service-api
  'fr-db-s2':
      - service-cms