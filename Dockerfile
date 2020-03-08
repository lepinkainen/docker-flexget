FROM ubuntu:focal

RUN apt-get update && \
    apt-get install -y python3 python-pip ca-certificates locales unrar && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN pip install flexget cloudscraper deluge-client

ENV TZ=Europe/Helsinki

RUN mkdir -p /root/.config/flexget && mkdir -p /torrents
VOLUME ["/root/.config/flexget", "/torrents/"]

COPY start.sh /start.sh
ENTRYPOINT ["/start.sh"]
