=======
certbot
=======

Formula to generate and renew certificates through `certbot <https://certbot.eff.org/>`_, formerly known as letsencrypt.

See the full `Salt Formulas installation and usage instructions
<http://docs.saltstack.com/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``certbot``
-----------

Generate letsencrypt certificate for the owned domain and add this certificate to nginx. It also add a cron entry to renew the certificates that are valid for 90 days. See this `blog entry <https://serversforhackers.com/video/letsencrypt-for-free-easy-ssl-certificates>`_ for more information about this process.