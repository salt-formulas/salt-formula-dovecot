{%- if pillar.dovecot.server is defined %}
include:
- dovecot.server
{%- endif %}
