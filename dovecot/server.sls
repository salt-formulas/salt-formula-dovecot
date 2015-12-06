{% from "dovecot/map.jinja" import server with context %}

{%- if server.enabled %}

include:
- dovecot.server.common
{%- if server.service.director.get('enabled', False) and server.service.director.get('separate_instance', False) %}
- dovecot.server.director
{%- endif %}

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

dovecot_service:
  service.running:
    - name: {{ server.service_name }}
    - require:
      - file: dovecot_config

{%- if server.index.get('enabled', True) %}

dovecot_index_dir:
  file.directory:
    - name: {{ server.index.path }}
    - owner: vmail
    - group: vmail
    - mode: 0770
    - require:
      - pkg: dovecot_packages
    - required_in:
      - service: dovecot_service

{%- endif %}

dovecot_sieve_dir:
  file.directory:
  - name: /var/lib/dovecot/sieve
  - group: vmail
  - mode: 775
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

{%- if server.expunge.enabled %}

cron_expunge_junk:
  cron.present:
    - name: doveadm expunge -A mailbox Junk savedbefore {{ server.expunge.junk_days }}d
    - hour: 1
    - minute: random

cron_expunge_trash:
  cron.present:
    - name: doveadm expunge -A mailbox Trash savedbefore {{ server.expunge.trash_days }}d
    - hour: 2
    - minute: random

{%- endif %}

{%- endif %}
