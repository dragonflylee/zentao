FROM ubuntu:16.04
MAINTAINER yidong <yidong@cnezsoft.com>

RUN apt-get update && apt-get install -y apache2 mariadb-server php php-curl php-gd php-ldap php-mbstring php-mcrypt php-mysql php-xml php-zip php-cli php-json curl unzip libapache2-mod-php locales

ENV LANG="en_US.UTF8"
ENV MYSQL_ROOT_PASSWORD="123456"
RUN echo -e "LANG=\"en_US.UTF-8\"\nLANGUAGE=\"en_US:en\"" > /etc/default/locale && locale-gen en_US.UTF-8

RUN mkdir -p /app/zentaopms /app/xxd
COPY docker-entrypoint.sh /app
RUN chmod 777 /app/docker-entrypoint.sh
RUN curl http://dl.cnezsoft.com/zentao/11.7/ZenTaoPMS.11.7.stable.zip -o /var/www/zentao.zip && cd /var/www/ && unzip -q zentao.zip && rm zentao.zip
RUN curl http://dl.cnezsoft.com/xuanxuan/3.0.beta4/xxd.3.0.beta4.linux.x64.tar.gz -o xxd.tar.gz && tar zxf xxd.tar.gz -C /app/xxd --strip-components=1 && rm xxd.tar.gz && /app/xxd/xxd -service install
RUN a2enmod rewrite

RUN rm -rf /etc/apache2/sites-enabled/000-default.conf /var/lib/mysql/*
RUN sed -i '1i ServerName 127.0.0.1' /etc/apache2/apache2.conf
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY ioncube_loader_lin_7.0.so /usr/lib/php/20151012/ioncube_loader_lin_7.0.so
COPY 00-ioncube.ini /etc/php/7.0/apache2/conf.d/
COPY 00-ioncube.ini /etc/php/7.0/cli/conf.d/

VOLUME /app/zentaopms/tmp /app/zentaopms/config /app/zentaopms/www/data /var/lib/mysql
ENTRYPOINT ["/app/docker-entrypoint.sh"]
