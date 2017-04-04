{% from "dovecot/map.jinja" import server with context %}

{%- if server.get('passdb', {}).get('driver', 'mysql') == 'mysql' %}
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
  {%- if not grains.get('noservices', False)%}
  - watch_in:
    - service: dovecot_service
  {%- endif %}
{%- elif server.get('passdb', {}).get('driver', 'mysql') == 'ldap' %}
dovecot_ldap_config:
  file.managed:
  - name: /etc/dovecot/dovecot-ldap.conf
  - source: salt://dovecot/files/dovecot-ldap.conf
  - mode: 640
  - user: root
  - group: dovecot
  - template: jinja
  - require:
    - pkg: dovecot_packages
  {%- if not grains.get('noservices', False)%}
  - watch_in:
    - service: dovecot_service
  {%- endif %}
{%- endif %}

{%- if server.get('userdb', {}).get('driver', 'mysql') == 'ldap' %}
dovecot_ldap_userdb_config:
  file.managed:
  - name: /etc/dovecot/dovecot-ldap-userdb.conf
  - source: salt://dovecot/files/dovecot-ldap.conf
  - mode: 640
  - user: root
  - group: dovecot
  - template: jinja
  - require:
    - pkg: dovecot_packages
  {%- if not grains.get('noservices', False)%}
  - watch_in:
    - service: dovecot_service
  {%- endif %}
{%- endif %}

dovecot_packages:
  pkg.installed:
    - names: {{ server.pkgs }}
    {%- if not grains.get('noservices', False)%}
    - watch_in:
      - service: dovecot_service
    {%- endif %}

{%- if server.ssl.get('enabled', False) %}

{%- if server.ssl.key is defined %}
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
  {%- if not grains.get('noservices', False)%}
  - watch_in:
    - service: dovecot_service
  {%- endif %}

/etc/dovecot/ssl/ssl_key.key:
  file.managed:
  - contents_pillar: dovecot:server:ssl:key
  - user: root
  - group: dovecot
  - mode: 640
  - require:
    - file: /etc/dovecot/ssl
  {%- if not grains.get('noservices', False)%}
  - watch_in:
    - service: dovecot_service
  {%- endif %}
{%- endif %}

{%- endif %}
