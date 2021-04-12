FROM ubuntu:focal

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV TZ=Europe/Helsinki

# Set locale, this should be a static layer done only when LANG is changed
RUN apt-get clean && apt-get update && apt-get install -y locales && locale-gen $LANG && rm -rf /var/lib/apt/lists/*

# Timezone shouldn't change after initial build, so do it first because layers
# From https://github.com/moby/moby/issues/12084#issuecomment-299813445
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# enable universe repo
RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository universe && rm -rf /var/lib/apt/lists/*

# Install basic stuff
RUN apt-get update && apt-get install -y python3 python3-pip ca-certificates locales unrar && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Install flexget and the python packages it needs
RUN pip3 install flexget cloudscraper deluge-client python-telegram-bot

# Create required directories and mount the volumes
RUN mkdir -p /root/.config/flexget && mkdir -p /torrents
VOLUME ["/root/.config/flexget", "/torrents/"]

# Startup script
COPY start.sh /start.sh
RUN chmod a+x /start.sh
ENTRYPOINT ["/start.sh"]
