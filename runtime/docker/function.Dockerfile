ARG AWS_TAG

ARG ARCHITECTURE

ARG PHP_VERSION

FROM bref/${ARCHITECTURE}-${PHP_VERSION}-base as base
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-mbstring as mbstring
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-bcmath as bcmath
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-ctype as ctype
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-dom as dom
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-exif as exif
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-fileinfo as fileinfo
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-ftp as ftp
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-gettext as gettext
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-iconv as iconv
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-mysqli as mysqli
FROM bref/${ARCHITECTURE}-${PHP_VERSION}-ext-opcache as opcache

FROM public.ecr.aws/lambda/provided:${AWS_TAG}

COPY --from=base /bref /opt

COPY runtime/configuration/bootstrap /opt/bootstrap
COPY runtime/configuration/bootstrap /var/runtime/bootstrap
COPY runtime/configuration/bref.ini /opt/php-ini/bref.ini
COPY runtime/configuration/bref-ext.ini /opt/php-ini/bref-ext.ini
COPY runtime/configuration/bref-ext-opcache.ini /opt/php-ini/bref-ext-opcache.ini



RUN chmod +x /opt/bootstrap
RUN chmod +x /var/runtime/bootstrap

COPY --from=mbstring /opt/lib/* /opt/lib/
COPY --from=mbstring /opt/php-modules/mbstring.so /opt/php-modules/mbstring.so

COPY --from=bcmath /opt/php-modules/bcmath.so /opt/php-modules/bcmath.so
COPY --from=ctype /opt/php-modules/ctype.so /opt/php-modules/ctype.so
COPY --from=dom /opt/php-modules/dom.so /opt/php-modules/dom.so
COPY --from=exif /opt/php-modules/exif.so /opt/php-modules/exif.so
COPY --from=fileinfo /opt/php-modules/fileinfo.so /opt/php-modules/fileinfo.so
COPY --from=ftp /opt/php-modules/ftp.so /opt/php-modules/ftp.so
COPY --from=gettext /opt/php-modules/gettext.so /opt/php-modules/gettext.so
COPY --from=iconv /opt/php-modules/iconv.so /opt/php-modules/iconv.so
COPY --from=mysqli /opt/php-modules/mysqli.so /opt/php-modules/mysqli.so
COPY --from=mysqli /opt/php-modules/mysqlnd.so /opt/php-modules/mysqlnd.so
COPY --from=opcache /opt/php-modules/opcache.so /opt/php-modules/opcache.so

COPY src/Context/Context.php /opt/bref-src/Context/Context.php
COPY src/Context/ContextBuilder.php /opt/bref-src/Context/ContextBuilder.php
COPY src/Toolbox/bootstrap.php /opt/bref-src/Toolbox/bootstrap.php
COPY src/Toolbox/Runner.php /opt/bref-src/Toolbox/Runner.php
COPY src/Toolbox/VendorDownloader.php /opt/bref-src/Toolbox/VendorDownloader.php
COPY src/Runtime/Invoker.php /opt/bref-src/Runtime/Invoker.php
COPY src/Runtime/LambdaRuntime.php /opt/bref-src/Runtime/LambdaRuntime.php