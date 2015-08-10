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
