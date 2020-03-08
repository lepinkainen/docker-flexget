FROM ubuntu:focal

RUN apt-get update && \
    apt-get install -y python3 python-pip ca-certificates locales && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN pip install flexget cloudscraper deluge-client

RUN mkdir -p /root/.config/flexget

VOLUME ["/root/.config/flexget"]

RUN mkdir -p /torrents

VOLUME ["/torrents"]

ENTRYPOINT ["flexget daemon start --autoreload-config"]
