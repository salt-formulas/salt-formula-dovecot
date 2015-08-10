{% from "dovecot/map.jinja" import server with context %}

{%- if server.enabled %}

dovecot_config:
  file.managed:
  - name: /etc/dovecot/dovecot.conf
  - source: salt://dovecot/files/dovecot.conf
  - mode: 640
  - user: root
  - group: dovecot
  - template: jinja
  - require:
    - pkg: dovecot_packages
  - watch_in:
    - service: dovecot_service

dovecot_sql_config:
  file.managed:
  - name: /etc/dovecot/dovecot-sql.conf
  - source: salt://dovecot/files/dovecot-sql.conf
  - mode: 640
  - user: root
  - group: dovecot
  - template: jinja
  - require:
    - pkg: dovecot_packages
  - watch_in:
    - service: dovecot_service

dovecot_packages:
  pkg.installed:
    - names: {{ server.pkgs }}
    - watch_in:
      service: dovecot_service

dovecot_service:
  service.running:
    - name: {{ server.service }}
    - require:
      - file: dovecot_config

{%- endif %}
