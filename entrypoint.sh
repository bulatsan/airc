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
