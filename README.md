# docker-tor-wordpress [![Release Github Packages](https://github.com/antyung88/docker-tor-wordpress/actions/workflows/release.yml/badge.svg)](https://github.com/antyung88/docker-tor-wordpress/actions/workflows/release.yml)

tor proxy pass WordPress in Docker

# Usage

Git Clone Repository

```
git clone https://github.com/antyung88/docker-tor-wordpress.git && cd docker-tor-wordpress
```

Wait to the container image be downloaded. And them we can generate our site skeleton:

```
docker run -it --rm -v $(pwd)/web:/web ghcr.io/antyung88/tor-wordpress:stable generate CHANGE_ME
```
```
[+] Generating the address with mask: CHANGE_ME
[+] Found matching domain after 137072 tries: CHANGE_MEfyygjp5st54g.onion
[+] Generating nginx configuration for site  CHANGE_MEfyygjp5st54g.onion
[+] Creating www folder
[+] Generating index.html template
```

Now we have our skeleton generated, we can run the container with:
```
docker-compose up -d
```
