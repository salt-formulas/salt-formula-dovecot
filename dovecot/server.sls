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

{%- if server.ssl.get('enabled', False) %}

/etc/dovecot/ssl:
  file.directory:
  - user: root
  - group: dovecot
  - mode: 750
  - require:
    - pkg: dovecot_packages

/etc/dovecot/ssl/ssl_cert.crt:
  file.managed:
  - source: salt://dovecot/files/ssl_cert_all.crt
  - template: jinja
  - user: root
  - group: dovecot
  - mode: 640
  - require:
    - file: /etc/dovecot/ssl
  - watch_in:
    - service: dovecot_service

/etc/dovecot/ssl/ssl_key.key:
  file.managed:
  - contents_pillar: dovecot:server:ssl:key
  - user: root
  - group: dovecot
  - mode: 640
  - require:
    - file: /etc/dovecot/ssl
  - watch_in:
    - service: dovecot_service

{%- endif %}

dovecot_sieve_dir:
  file.directory:
  - name: /var/lib/dovecot/sieve
  - require:
    - pkg: dovecot_packages

dovecot_default_sieve:
  file.managed:
  - name: /var/lib/dovecot/sieve/default.sieve
  - source: salt://dovecot/files/default.sieve
  - template: jinja
  - require:
    - file: dovecot_sieve_dir

dovecot_default_sieve_compile:
  cmd.wait:
  - name: sievec /var/lib/dovecot/sieve/default.sieve
  - watch:
    - file: dovecot_default_sieve

{%- endif %}
