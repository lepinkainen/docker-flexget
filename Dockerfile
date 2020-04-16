FROM ubuntu:focal

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG en_US.UTF-8

ENV TZ=Europe/Helsinki

# Timezone shouldn't change after initial build, so do it first because layers
# From https://github.com/moby/moby/issues/12084#issuecomment-299813445
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

# Python-pip requires universe repo nowadays
RUN add-apt-repository universe

# Install basic stuff  
RUN apt-get update && \
    apt-get install -y python3 python-pip ca-certificates locales unrar && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Python packages
RUN pip install flexget cloudscraper deluge-client python-telegram-bot

RUN mkdir -p /root/.config/flexget && mkdir -p /torrents
VOLUME ["/root/.config/flexget", "/torrents/"]

COPY start.sh /start.sh
RUN chmod a+x /start.sh
ENTRYPOINT ["/start.sh"]
