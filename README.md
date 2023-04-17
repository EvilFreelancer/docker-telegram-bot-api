# Telegram Bot API Docker

This project provides a Docker container for the
[Telegram Bot API](https://github.com/tdlib/telegram-bot-api)
server. With this container, you can quickly and easily deploy the
Telegram Bot API server with customizable settings using
environment variables.

## Getting Started

To get started, first clone the repository:

```shell
git clone https://github.com/EvilFreelancer/docker-telegram-bot-api.git
cd docker-telegram-bot-api
```

Next, create a `docker-compose.yml` file by copying the provided
`docker-compose.dist.yml`:

```shell
cp docker-compose.dist.yml docker-compose.yml
```

You can customize the settings in the `docker-compose.yml` file by
setting the appropriate environment variables.

It is essential to replace the default values for `TELEGRAM_API_ID`
and `TELEGRAM_API_HASH` with your own credentials. You can obtain
these credentials from the [Telegram Core API](https://my.telegram.org) website.

Below is a table describing each available variable:

| Variable                         | Description                                              | Default |
|----------------------------------|----------------------------------------------------------|---------|
| TELEGRAM_STAT                    | Enable the HTTP statistics API. Set to "true" to enable. | false   |
| TELEGRAM_LOCAL                   | Enable local mode. Set to "true" to enable.              | false   | 
| TELEGRAM_API_ID                  | Your Telegram API ID.                                    |         |
| TELEGRAM_API_HASH                | Your Telegram API Hash.                                  |         |
| TELEGRAM_LOG_FILE                | Path to the log file.                                    |         |
| TELEGRAM_FILTER                  | Filter users and chats to restrict access.               |         |
| TELEGRAM_MAX_WEBHOOK_CONNECTIONS | Set the maximum number of webhook connections.           |         |
| TELEGRAM_VERBOSITY               | Set the log verbosity level.                             |         |
| TELEGRAM_MAX_CONNECTIONS         | Set the maximum number of connections.                   |         |
| TELEGRAM_PROXY                   | Set a proxy server for the Telegram Bot API.             |         |
| TELEGRAM_HTTP_IP_ADDRESS         | Set the IP address to bind the HTTP server to.           |         |

## Using the Pre-built Docker Image

If you prefer not to build the Docker image yourself, you can use
the pre-built image available on Docker Hub. This image is
automatically built and pushed to Docker Hub whenever a new
commit is made to the [tdlib/telegram-bot-api](https://github.com/tdlib/telegram-bot-api) repository.

To use the pre-built Docker image, update the `docker-compose.yml`
file with the pre-built image details:

```yaml
version: "3.9"

services:
  telegram-bot-api:
    restart: unless-stopped
    image: evilfreelancer/docker-telegram-bot-api:latest # use image instead of build.context
    environment:
      TELEGRAM_STAT: "true"
      TELEGRAM_LOCAL: "true"
      TELEGRAM_API_ID: "123"
      TELEGRAM_API_HASH: "hash"
    volumes:
      - ./telegram-bot-api_data:/var/lib/telegram-bot-api
    ports:
      - "127.0.0.1:8081:8081"
      - "127.0.0.1:8082:8082"
    logging:
      driver: "json-file"
      options:
        max-size: "50k"
```

## Customizing Telegram Bot API Version

Additionally, you can specify a specific branch, tag, or commit of
the Telegram Bot API during the build process by setting the
`TELEGRAM_API_REF` build argument. This argument can be customized
in the `docker-compose.yml` file under the `args` section in the
`build` block.

For example, if you want to build the container using a specific
release, such as `v1.2.3`, you can set the `TELEGRAM_API_REF` in
the `docker-compose.yml` file:

```yaml
services:
  telegram-bot-api:
    build:
      context: ./telegram-bot-api
      args:
        TELEGRAM_API_REF: v1.2.3
    # Remaining docker-compose.yml contents...
```

By default, if the `TELEGRAM_API_REF` argument is not set, the latest
commit on the `master` branch will be used.

## Configuring Ports

The Telegram Bot API server exposes two ports by default:

* `8081`: The main API port for receiving updates and sending requests to the server.
* `8082`: The statistics port for monitoring the server's performance and activity (only available when `TELEGRAM_STAT` is set to "true").

In the docker-compose.yml file, you can configure the ports mapping
between the host machine and the container. The provided
`docker-compose.dist.yml` file contains the following port mappings:

```yaml
ports:
  - "127.0.0.1:8081:8081"
  - "127.0.0.1:8082:8082"
```

This configuration binds the container's port `8081` to the host's
port `8081` and the container's port `8082` to the host's port
`8082`. Both ports are bound to the localhost (`127.0.0.1`) to
restrict access to the local machine.

### Customizing Port Bindings

If you need to change the host port or bind the ports to a different
IP address, you can modify the `ports` section in the
`docker-compose.yml` file. For example, to bind the main API port
to `8000` and make it accessible from any IP address, you can
update the configuration like this:

```yaml
ports:
  - "0.0.0.0:8000:8081"
  - "127.0.0.1:8082:8082"
```

With this configuration, the Telegram Bot API server will be
accessible on port `8000` from any IP address, while the statistics
port will still be restricted to localhost access on port `8082`.

## Running the Telegram Bot API Server

### Building and Running the Container

Once you've configured the `docker-compose.yml` file, you can start
the Telegram Bot API server by running:

```shell
docker-compose up -d
```

The `-d` flag will start the container in detached mode, allowing
it to run in the background.

### Viewing Logs

To view the logs of the running Telegram Bot API server, you can
use the following command:

```shell
docker-compose logs -f telegram-bot-api
```

The `-f` flag will follow the logs in real-time, allowing you to monitor
the server's output as events occur.

### Stopping the Container

If you need to stop the Telegram Bot API server, you can use the
following command:

```shell
docker-compose down
```

This command will stop and remove the running container. Note that
this will not remove the Docker image that you built earlier.

### Rebuilding the Container

If you make changes to the `docker-compose.yml` file or the `Dockerfile`,
you'll need to rebuild the container. To do this, first stop the
running container using the `docker-compose down` command. Then,
build and start the updated container with the following command:

```shell
docker-compose up -d --build
```

The `--build` flag ensures that the Docker image is rebuilt before
starting the container.

## Links

* [Official Telegram Bot API Repository](https://github.com/tdlib/telegram-bot-api)
* [TDLight Bot API features](https://github.com/tdlight-team/tdlight-telegram-bot-api)
