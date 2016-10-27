# What is this image?

This image provides a Flyway image with Postgres' psql tool and a ready script in order to check whether PostgreSQL db is initialized to kick Flyway off.

# Getting Started

There are two scenarios in which this image could be used. Docker Compose and Docker CLI. You may find example setup in `https://github.com/gokhansengun/Docker-Hub-Flyway-Postgres/tree/master/test`.

## Docker Compose

Below steps examplify the usage of the image in the Docker Compose version 2 (Docker for Mac and Docker for Windows).

Create a `docker-compose.yml` file like below. There are two services, one service is the Postgres DB itself. The other service is the Flyway migrator. You should have your migration sql files under the `sql` directory which is placed under the same directory as `docker-compose.yml` file.

Below, the command for `flyway-migrator` is in the format of `<DB_IP_OR_NAME> <DB_PORT> <DB_USERNAME> <DB_PASSWORD> <DB_NAME> <SCHEMA_NAME>`

```docker
version: '2'

services:

  postgres-db:
    image: postgres:9.3
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_PASSWORD=secret

  flyway-migrator:
    image: gsengun/flyway-postgres
    volumes:
      - ./sql:/flyway/sql
    depends_on:
      - postgres-db
    command: postgres-db 5432 postgres secret postgres public
```

Open a terminal and run the service using `docker-compose up flyway-migrator`

## Docker CLI

Below steps examplify the usage of the image in the Docker CLI.

Open a terminal and navigate to the `sql` folder containing your migration sql files. Run the command below.

```
docker run --rm -v `pwd`/sql:/flyway/sql gsengun/flyway-postgres <DB_IP_OR_NAME> <DB_PORT> <DB_USERNAME> <DB_PASSWORD> <DB_NAME> <SCHEMA_NAME>
```

example command:

```
docker run --rm -v `pwd`/sql:/flyway/sql gsengun/flyway-postgres 192.168.1.35 5432 postgres secret postgres public
```


