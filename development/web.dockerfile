FROM nginx:1.19.5-alpine

ADD development/vhost.conf /etc/nginx/conf.d/default.conf

COPY public /var/www/public