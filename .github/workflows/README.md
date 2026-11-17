# baikal-docker

Unofficial multi-arch Docker image for [Baïkal](https://github.com/sabre-io/Baikal) (CalDAV/CardDAV),
built straight from the official release zip. Platforms: `linux/amd64`, `linux/arm64`, `linux/arm/v7`
(e.g. QNAP NAS with Annapurna Labs Alpine chips).

A GitHub Action checks daily for a new upstream release and builds it automatically.

## Setup (one time)

1. Create a new GitHub repo, e.g. `baikal-docker`, and push these files.
2. Actions tab → **Build Baikal image** → **Run workflow** for the first build.
3. After the first build: GitHub profile → **Packages** → `baikal` → Package settings →
   set visibility to **Public** (otherwise the NAS needs a login to pull).

Image: `ghcr.io/<your-username>/baikal:latest` (or a fixed version tag like `:0.10.1`).

## Run on the NAS (Container Station → Applications → Create)

```yaml
services:
  baikal:
    image: ghcr.io/<your-username>/baikal:latest
    container_name: baikal
    ports:
      - "8800:80"
    volumes:
      - /share/Container/baikal/config:/var/www/baikal/config
      - /share/Container/baikal/Specific:/var/www/baikal/Specific
    restart: unless-stopped
```

Before the first start (SSH on the NAS):

```sh
mkdir -p /share/Container/baikal/config /share/Container/baikal/Specific
chown 33:33 /share/Container/baikal/config /share/Container/baikal/Specific
```

Then open `http://nas-ip:8800/`, run the wizard and choose SQLite.
DAVx5 URL: `http://nas-ip:8800/dav.php/`

## Updates

New Baïkal release → the Action builds it within a day → in Container Station, pull the image
again and recreate the container. Back up `config` and `Specific` before major version jumps.

## Licence

Baïkal is GPL-3.0. This repo only contains build files.
