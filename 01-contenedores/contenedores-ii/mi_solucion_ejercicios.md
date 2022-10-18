### Ejercicio 1

```sh
docker build -t simple-apache:new .

docker run -d -p 8080:80 simple-apache:new
```

### Ejercicio 2

```sh
docker run --name my_apache -d -p 5050:80 simple-apache:new
```

### Ejercicio 3

Con `dive simple-apache:new` me salen 6:

```
┃ ● Layers ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
Cmp   Size  Command
     80 MB  FROM b317814a72f3433
       0 B  mkdir -p "$HTTPD_PREFIX"  && chown www-data:www-data "$HTTPD_PREFIX"
    4.7 MB  set -eux;  apt-get update;  apt-get install -y --no-install-recommends   ca-certificates   li
     60 MB  set -eux;   savedAptMark="$(apt-mark showmanual)";  apt-get update;  apt-get install -y --no-
     138 B  #(nop) COPY file:c432ff61c4993ecdef4786f48d91a96f8f0707f6179816ccb98db661bfb96b90 in /usr/loc
     327 B  #(nop) COPY dir:ff69eac8b5ecdc015d472a93a1b387c4c31465c1524fb97b4658b6e24971ab8e in /usr/loca
```

Con `docker image inspect simple-apache:new` también me salen 6:

```
[...]
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:b45078e74ec97c5e600f6d5de8ce6254094fb3cb4dc5e1cc8335fb31664af66e",
                "sha256:dbe439db2670b2b788eb47285f82306fd2552d8f62bae06dd5f3e89e3e7e7573",
                "sha256:a2a695c8a65c82c25811b1a91fc050ee45e24da55a274856d8653b0ff729b29a",
                "sha256:91a4ee018a73ed952ff68af630f42765b2a23e0786a97c08eb5e93979c01d3ed",
                "sha256:fb69cbbd27337ba9dfdfec817e5cf8bf24b97e4cfb957b3d31f1b3d22d21ea74",
                "sha256:3189bc166237608f3740304cbefc3821fdf95c340b4be89a86a51eb3aaf2cc21"
            ]
        },
[...]
```

Con `docker history --help simple-apache:new` me salen bastantes más (19):

```
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
7d1d7fbee8de   55 minutes ago   /bin/sh -c #(nop) COPY dir:ff69eac8b5ecdc015…   327B
ebb0b4d00b04   55 minutes ago   /bin/sh -c #(nop)  EXPOSE 80                    0B
e0af801364d7   55 minutes ago   /bin/sh -c #(nop)  LABEL project=lemoncode      0B
eb8f850b95ab   55 minutes ago   /bin/sh -c #(nop)  LABEL maintainer=gisela.t…   0B
f2789344c573   2 weeks ago      /bin/sh -c #(nop)  CMD ["httpd-foreground"]     0B
<missing>      2 weeks ago      /bin/sh -c #(nop)  EXPOSE 80                    0B
<missing>      2 weeks ago      /bin/sh -c #(nop) COPY file:c432ff61c4993ecd…   138B
<missing>      2 weeks ago      /bin/sh -c #(nop)  STOPSIGNAL SIGWINCH          0B
<missing>      2 weeks ago      /bin/sh -c set -eux;   savedAptMark="$(apt-m…   59.9MB
<missing>      2 weeks ago      /bin/sh -c #(nop)  ENV HTTPD_PATCHES=           0B
<missing>      2 weeks ago      /bin/sh -c #(nop)  ENV HTTPD_SHA256=eb397fee…   0B
<missing>      2 weeks ago      /bin/sh -c #(nop)  ENV HTTPD_VERSION=2.4.54     0B
<missing>      2 weeks ago      /bin/sh -c set -eux;  apt-get update;  apt-g…   4.76MB
<missing>      2 weeks ago      /bin/sh -c #(nop) WORKDIR /usr/local/apache2    0B
<missing>      2 weeks ago      /bin/sh -c mkdir -p "$HTTPD_PREFIX"  && chow…   0B
<missing>      2 weeks ago      /bin/sh -c #(nop)  ENV PATH=/usr/local/apach…   0B
<missing>      2 weeks ago      /bin/sh -c #(nop)  ENV HTTPD_PREFIX=/usr/loc…   0B
<missing>      2 weeks ago      /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      2 weeks ago      /bin/sh -c #(nop) ADD file:5bd53bff884e470b3…   80.5MB
```
