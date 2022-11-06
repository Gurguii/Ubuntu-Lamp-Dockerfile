FROM ubuntu:latest

ENTRYPOINT /bin/bash

RUN apt update && apt upgrade -y

RUN apt install -y vim nano curl wget git apache2 mysql-server

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y php libapache2-mod-evasive php-mysql libapache2-mod-php libapache2-mod-security2

RUN openssl req -x509 -newkey rsa:4096 -nodes -keyout /etc/ssl/private/lamp.key -out /etc/ssl/certs/lamp.crt -days 365 -subj /CN=lamp.es

COPY lamp /var/www/lamp

WORKDIR /etc/apache2/

COPY conf/lamp.conf sites-available/lamp.conf

RUN rm sites-enabled/*
RUN a2enmod ssl security2 evasive && a2dismod autoindex -f && a2ensite lamp.conf

RUN mkdir modsecurity-crs
RUN wget https://github.com/coreruleset/coreruleset/archive/v3.3.0.tar.gz
RUN tar -xf v3.3.0.tar.gz
RUN mv coreruleset-3.3.0 modsecurity-crs/ && mv modsecurity-crs/coreruleset-3.3.0/crs-setup.conf.example modsecurity-crs/coreruleset-3.3.0/crs-setup.conf

COPY conf/security2.conf mods-available/

RUN rm /etc/modsecurity/modsecurity.conf-recommended

COPY conf/modsecurity.conf /etc/modsecurity/
COPY conf/evasive.conf /etc/apache2/mods-available/evasive.conf 
COPY .mysql.queries /root/mysql.queries
COPY .startup.sh /bin/startup.sh

RUN service mysql start && mysql -uroot < /root/mysql.queries
RUN rm /root/mysql.queries
RUN chmod +x /bin/startup.sh

WORKDIR /var/www

ENV HOSTNAME Ubuntu_Lamp
