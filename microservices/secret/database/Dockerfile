FROM percona:5.7

RUN mkdir -p /mount/mysql-keyring/ \
    && touch /mount/mysql-keyring/keyring \
    && chown -R mysql:mysql /mount/mysql-keyring

COPY etc/ /etc/mysql/conf.d/
