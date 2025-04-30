# airc
A lightweight wrapper around [air](https://github.com/air-verse/air) that lets you override the Go build command & source path via environment variables.

## why
I needed a more up-to-date Go runtime than the standard `cosmtrek/air` container, and I wanted to be able to point at different `main.go` files per service without writing building commands each time.

## what’s [inside](entrypoint.sh)
```sh
#!/bin/sh

: "${AIRC_SRC:=./cmd/app/main.go}"
: "${AIRC_BIN:=/tmp/app}"
: "${AIRC_CMD:=go build -o $AIRC_BIN $AIRC_SRC}"
: "${AIRC_DELAY:=1000}"

exec air \
  -build.bin               "$AIRC_BIN" \
  -build.cmd               "$AIRC_CMD" \
  -build.delay             "$AIRC_DELAY" \
  -build.send_interrupt    "true" \
  -log.silent              "true" \
  "$@"
```

## usage
```yml
# docker-compose.yml

services:
  httpapi:
    image: bulatsan/airc:latest
    environment:
      AIRC_SRC: ./cmd/httpapi/main.go
    # ... 

  grpcapi:
    image: bulatsan/airc:latest
    environment:
      AIRC_SRC: ./cmd/grpcapi/main.go
    # ...

  redisworker:
    image: bulatsan/airc:latest
    environment:
      AIRC_SRC: ./cmd/redisworker/main.go
    # ...

  kafkaconsumer:
    image: bulatsan/airc:latest
    # if you need more advanced behaviour you can easily provide your own air arguments
    command: >-
      -build.bin "./tmp/main"
      -build.cmd "go build -o ./tmp/main ./cmd/api/main.go"
      -build.kill_delay "1s"
      -log.silent "false"
    # ...
```
