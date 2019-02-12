{% from "trickster/map.jinja" import trickster with context %}

trickster_config:
  file.managed:
    - name: {{ trickster.config_file }}
    - source: salt://trickster/templates/trickster.config
    - template: jinja
    - makedirs: true

trickster_service:
  file.managed:
    - name: /etc/systemd/system/trickster.service
    - source: salt://trickster/templates/trickster.service
    - template: jinja

trickster_download:
  file.managed:
    - name: /opt/trickster/trickster.gz
    - makedirs: true
    - mode: 740
    - source: https://github.com/Comcast/trickster/releases/download/v0.1.6/trickster-0.1.6.linux-amd64.gz
    - source_hash: sha256=84f50775c8abddba5e10d43cb5bbb11a4d54d5922a70a86ab57eeba45efbe778
    - unless: ls /opt/trickster/trickster

trickster_unzip:
   module.run:
    - name: archive.gunzip
    - gzipfile: /opt/trickster/trickster.gz
    - onchanges: [ { file: /opt/trickster/trickster.gz } ]

trickster_running:
   service.running:
    - name: trickster
    - enable: True
    - require:
      - trickster_download
      - trickster_service
