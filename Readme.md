[![ci](https://github.com/lepinkainen/docker-flexget/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/lepinkainen/docker-flexget/actions/workflows/build.yml)

# Dockerized Flexget with Deluge

This requires that the network 'deluge' is created externally with `docker network create deluge`

## Flexget / docker-compose.yml

```
version: '3'
services:
  flexget:
    container_name: flexget
    image: lepinkainen/docker-flexget
    volumes:
        - ./config/:/root/.config/flexget/
        - /mnt/torrents/:/torrents/
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Helsinki
    restart: unless-stopped
    networks:
      - deluge

networks:
  deluge:
    external: true
```

## Deluge / docker-compose.yml

```
version: "3"
services:
  deluge:
    image: linuxserver/deluge
    container_name: deluge
    ports:
      - "8112:8112"
      - "58846:58846"
      - "58847:58847"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Helsinki
      - UMASK_SET=022 #optional
      - DELUGE_LOGLEVEL=error #optional
    volumes:
      - ./config:/config
      - /mnt/torrents/:/downloads
    restart: unless-stopped
    networks:
      - deluge

networks:
  deluge:
    external: true
```
