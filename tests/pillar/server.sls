dovecot:
  server:
    enabled: true
    admin: postmaster@local
    password_scheme: PLAIN-MD5
    debug: false
    verbose: true
    nfs: true
    mailbox_base: /srv/mail
    myorigin: host
    index:
      enabled: true
      path: /var/lib/dovecot/index
    expunge:
      enabled: true
      junk_days: 60
      trash_days: 90
    service:
      imap:
        enabled: true
        vsz_limit: 64
      pop3:
        enabled: true
        vsz_limit: 64
      lmtp:
        enabled: true
        process_min_avail: 5
        # Enable if you wish to use director for LMTP
        inet_enabled: false
        port: 24
      sieve:
        enabled: true
        vsz_limit: 64
      director:
        enabled: false
        port: 9090
    user:
      name: vmail
      group: vmail
      uid: 125
      gid: 125
      home: /srv
    mysql:
      user: mailserver
      database: mailserver
      password: password
      host: 127.0.0.1
    ssl:
      enabled: true
