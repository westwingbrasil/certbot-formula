{% from "certbot/default.jinja" import config with context %}

Get certbot:
  git.latest:
    - name: https://github.com/certbot/certbot.git
    - rev: master
    - target: /opt/certbot
    - force_clone: True
    - force_checkout: True

Update package dependencies:
  cmd.run:
    - name: ./certbot-auto --os-packages-only --non-interactive
    - cwd: /opt/certbot

Generate strong Diffie-Hellman group:
  cmd.run:
    - name: openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    - unless: test -f /etc/ssl/certs/dhparam.pem

Get certificate:
  cmd.run:
    - name: ./certbot-auto certonly --webroot -w {{ config.webroot }} -d {{ config.server_name }} --non-interactive --agree-tos --email {{ config.email }}
    - cwd: /opt/certbot
    - unless: test -d /etc/letsencrypt/live/{{ config.server_name }}

Install parameters file:
  file.managed:
    - name: /etc/nginx/snippets/ssl-params.conf
    - source: salt://certbot/files/ssl-params.conf

Ensure that crontab entry for certificate renew is present:
  cron.present:
    - name: /opt/certbot/certbot-auto renew >> /var/log/certbot-renew.log
    - user: root
    - minute: 0
    - hour: 3
    - daymonth: '*'
    - month: '*'
    - dayweek: 1

Ensure that crontab entry for reload configuration is present:
  cron.present:
    - name: /bin/systemctl reload nginx
    - user: root
    - minute: 10
    - hour: 3
    - daymonth: '*'
    - month: '*'
    - dayweek: 1