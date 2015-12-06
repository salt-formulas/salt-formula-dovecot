{% from "dovecot/map.jinja" import server with context %}

include:
- dovecot.server.common

dovecot_director_config:
  file.managed:
  - name: /etc/dovecot/dovecot-director.conf
  - source: salt://dovecot/files/dovecot-director.conf
  - mode: 640
  - user: root
  - group: dovecot
  - template: jinja
  - require:
    - pkg: dovecot_packages
  - watch_in:
    - service: dovecot_director_service

dovecot_director_upstart:
  file.managed:
  - name: /etc/init/dovecot-director.conf
  - source: salt://dovecot/files/dovecot-director.upstart
  - mode: 644
  - user: root
  - group: root
  - require:
    - pkg: dovecot_packages
  - watch_in:
    - service: dovecot_director_service

dovecot_director_service:
  service.running:
    - name: dovecot-director
    - require:
      - file: dovecot_director_config
      - file: dovecot_director_upstart
      - file: /var/run/dovecot-director

/var/run/dovecot-director:
  file.directory:
  - user: root
  - group: root
  - mode: 755
  - require:
    - pkg: dovecot_packages
