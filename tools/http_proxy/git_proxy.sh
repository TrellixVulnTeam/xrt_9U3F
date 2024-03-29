#!/bin/sh

on() {
  JQ_EXEC=`which jq`
  FILE_PATH=$1

  HOST=$(cat ${FILE_PATH} | ${JQ_EXEC} .proxy.host | sed 's/\"//g')
  PORT=$(cat ${FILE_PATH} | ${JQ_EXEC} .proxy.port | sed 's/\"//g')
  PROXY=${HOST}:${PORT}

  git config --global http.proxy http://${PROXY}
  git config --global https.proxy https://${PROXY}
}

off() {
  git config --global --unset http.proxy
  git config --global --unset https.proxy
}

status() {
  git config --global --get http.proxy
  git config --global --get https.proxy
}

main() {
    case $1 in
    on)
        on "$2"
        ;;
    off)
        off
        ;;
    status)
        status
        ;;
    *)
        echo
        echo "Usage: $0 { on | off | status }"
        echo
    ;;
    esac
}

main "$@"

