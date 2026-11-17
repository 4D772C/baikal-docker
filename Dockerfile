FROM php:8.2-apache

ARG BAIKAL_VERSION

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl unzip ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN test -n "$BAIKAL_VERSION" \
 && curl -fsSL -o /tmp/baikal.zip \
    "https://github.com/sabre-io/Baikal/releases/download/${BAIKAL_VERSION}/baikal-${BAIKAL_VERSION}.zip" \
 && unzip -q /tmp/baikal.zip -d /var/www/ \
 && rm /tmp/baikal.zip \
 && chown -R www-data:www-data /var/www/baikal/config /var/www/baikal/Specific

ENV APACHE_DOCUMENT_ROOT=/var/www/baikal/html
RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && a2enmod rewrite \
 && printf 'Redirect 301 /.well-known/caldav /dav.php\nRedirect 301 /.well-known/carddav /dav.php\n' \
    > /etc/apache2/conf-enabled/baikal-wellknown.conf

LABEL org.opencontainers.image.title="Baikal" \
      org.opencontainers.image.description="Unofficial multi-arch image of Baikal (CalDAV/CardDAV), incl. linux/arm/v7" \
      org.opencontainers.image.licenses="GPL-3.0" \
      org.opencontainers.image.version="${BAIKAL_VERSION}"

VOLUME ["/var/www/baikal/config", "/var/www/baikal/Specific"]
EXPOSE 80
