FROM nginx:alpine

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./nginx_azuracast.conf /etc/nginx/conf.d/azuracast.conf

VOLUME /etc/nginx/conf.d/

RUN apk update && \
    apk add openssl

RUN mkdir -p /etc/nginx/ssl/
RUN openssl req -new -nodes -x509 -subj "/C=US/ST=Texas/L=Austin/O=IT/CN=localhost" \
	-days 365 -extensions v3_ca \
	-keyout /etc/nginx/ssl/ssl.key \
	-out /etc/nginx/ssl/ssl.crt
RUN openssl dhparam -out /etc/nginx/dhparam.pem 4096

VOLUME /var/www/letsencrypt
VOLUME /etc/nginx/ssl

COPY ./scripts/letsencrypt_connect /usr/bin/letsencrypt_connect
RUN chmod a+x /usr/bin/letsencrypt_connect

EXPOSE 80 443
STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]