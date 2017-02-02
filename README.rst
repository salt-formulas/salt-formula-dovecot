=======
dovecot
=======

Install and configure dovecot.

Available states
================

.. contents::
    :local:

``dovecot.server``
------------------

Setup dovecot server

Available metadata
==================

.. contents::
    :local:

``metadata.dovecot.server``
---------------------------

Setup dovecot server

Requirements
============

- linux
- mysql (for mysql backend)

Optional
--------

- `glusterfs <https://github.com/tcpcloud/salt-glusterfs-formula>`_ (to serve as mail storage backend)
- `postfix <https://github.com/tcpcloud/salt-postfix-formula>`_
- `roundcube <https://github.com/tcpcloud/salt-roundcube-formula>`_

Configuration parameters
========================

For complete list of parameters, please check
``metadata/service/server.yml``

Example reclass
===============

Server
------

.. code-block:: yaml

   classes:
     - service.dovecot.server
   parameters:
    _param:
      dovecot_origin: mail.eru
      mysql_mailserver_password: Peixeilaephahmoosa2daihoh4yiaThe
    dovecot:
      server:
        origin: ${_param:dovecot_origin}
    mysql:
      server:
        database:
          mailserver:
            encoding: UTF8
            locale: cs_CZ
            users:
            - name: mailserver
              password: ${_param:mysql_mailserver_password}
              host: 127.0.0.1
              rights: all privileges
    apache:
      server:
        site:
          dovecotadmin:
            enabled: true
            type: static
            name: dovecotadmin
            root: /usr/share/dovecotadmin
            host:
              name: ${_param:dovecot_origin}
              aliases:
                - ${linux:system:name}.${linux:system:domain}
                - ${linux:system:name}

LDAP and GSSAPI
~~~~~~~~~~~~~~~

.. code-block:: yaml

    parameters:
      dovecot:
        server:
          gssapi:
            host: imap01.example.com
            keytab: /etc/dovecot/krb5.keytab
            realms:
              - example.com
            default_realm: example.com

          userdb:
            driver: ldap
          passdb:
            driver: ldap
          ldap:
            servers:
              - ldaps://idm01.example.com
              - ldaps://idm02.example.com
            basedn: dc=example,dc=com
            bind:
              dn: uid=dovecot,cn=users,cn=accounts,dc=example,dc=com
              password: password
            # Auth users by binding as them
            auth_bind:
              enabled: true
              userdn: "mail=%u,cn=users,cn=accounts,dc=example,dc=com"
            user_filter: "(&(objectClass=posixAccount)(mail=%u))"

Director
~~~~~~~~

Dovecot Director is used to ensure connection affinity to specific backends.
This seems to be a must-have for shared storage such as NFS, GlusterFS, etc.
otherwise you are going to meet split-brains, corrupted files and other
issues.

Unfortunately director for LMTP can't be used when director and backend
servers are the same.

See http://wiki2.dovecot.org/Director for more informations.

.. code-block:: yaml

    dovecot:
      server:
        admin: postmaster@${_param:postfix_origin}
        # GlusterFS storage is used
        nfs: true
        service:
          director:
            enabled: true
            port: 9090
            backends:
              - ${_param:cluster_node01_address}
              - ${_param:cluster_node02_address}
            directors:
              - ${_param:cluster_node01_address}
              - ${_param:cluster_node02_address}
          lmtp:
            inet_enabled: true
            port: 24
    postfix:
      server:
        dovecot_lmtp:
          enabled: true
          type: inet
          address: "localhost:24"

Example pillar
==============

Server
------

.. code-block:: yaml

    dovecot:
      server:
        origin: ${_param:dovecot_origin}
        admin:
          enabled: false

Read more
=========

* http://wiki2.dovecot.org/

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-dovecot/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-dovecot

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
