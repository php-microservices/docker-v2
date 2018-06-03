FROM mariadb:latest

RUN apt-get update \
    && apt-get autoremove && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

#RUN openssl enc -aes-256-ctr -k secret@phpmicroservices.com -P -md sha1
RUN mkdir -p /volumes/keys/
RUN echo "1;C472621BA1708682BEDC9816D677A4FDC51456B78659F183555A9A895EAC9218" > /volumes/keys/keys.txt

RUN openssl enc -aes-256-cbc -md sha1 -k secret -in /volumes/keys/keys.txt -out /volumes/keys/keys.enc

COPY etc/ /etc/mysql/conf.d/
