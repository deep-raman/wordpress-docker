FROM debian:buster-slim
LABEL maintainer="bat@raman.cat"
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apache2 libapache2-mod-php php-mysql php-gd php-xml php-intl php-redis wget ca-certificates && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    rm -f /var/www/html/index.html && \
    sed -i 's/^session.save_handler = files/session.save_handler = redis/g' /etc/php/7.3/apache2/php.ini && \
    sed -i '/session.save_handler/a session.save_path = "tcp:\/\/redis:6379"/g' /etc/php/7.3/apache2/php.ini && \
    wget -O- https://wordpress.org/latest.tar.gz | tar --strip-components=1 -C /var/www/html/ zxv
    

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
