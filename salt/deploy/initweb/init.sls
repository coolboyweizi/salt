# scp from one minions
{% set scripts = pillar['scripts'] %}
{% set project = pillar['project'] %}
{% set package = pillar['package'] %}

{% set hash_p = pillar['hash_p'] %}
{% set hash_s = pillar['hash_s'] %}

{% set project_root = pillar['website-project'] %}
{% set runtime_root = pillar['website-runtime'] %}
{% set package_root = pillar['website-package'] %}

{% set owner   =   pillar['website-owner'] %}

{% set section   = pillar[project]['section'] %}

runtime_directory:
  file.directory:
    - name: {{runtime_root}}
    - makedirs: True
    - user: {{owner}}
    - group: {{owner}}

project_directory:
  file.directory:
    - name: {{project_root}}
    - makedirs: True
    - user: {{owner}}
    - group: {{owner}}

package-directory:
  file.directory :
    - name: {{package_root}}/{{project}}
    - makedirs: True
    - user: {{owner}}
    - group: {{owner}}

# upload file to targets minions.
# package
package-up:
  file.managed:
    - name: {{package_root}}/{{project}}/{{package}}
    - source: salt://packages/{{project}}/{{package}}
    - user: {{owner}}
    - group: {{owner}}
    - source_hash: md5={{hash_p}}
    - require:
      - file: package-directory


script-up:
  file.managed:
    - name: {{package_root}}/{{project}}/{{scripts}}
    - source: salt://packages/{{project}}/{{scripts}}
    - user: {{owner}}
    - group: {{owner}}
    - source_hash: md5={{hash_s}}
    - mode: 744
    - require:
      - file: package-directory

script-run:
  cmd.run:
    - name: {{package_root}}/{{project}}/{{scripts}}  {{project}} {{package_root}}/{{project}}/{{package}} {{section}}
    - cwd: {{package_root}}/{{project}}
    - runas: {{owner}}
    - require:
      - file: script-up
      - file: package-up
      - file: runtime_directory
      - file: project_directory

