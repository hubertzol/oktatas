FROM php:7.4-fpm-alpine


RUN apk add --update-cache php


COPY composer.json /var/www/


COPY database /var/www/database


WORKDIR /var/www


RUN apk update && apk add git && apk add zip


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"


RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"


RUN php composer-setup.php


RUN php -r "unlink('composer-setup.php');"


RUN php composer.phar install --no-dev --no-scripts


RUN rm composer.phar


COPY . /var/www


RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache


RUN php artisan cache:clear


RUN php artisan route:clear


RUN php artisan optimize


RUN mv .env.prod .env


RUN php artisan optimize


RUN php artisan key:generate
