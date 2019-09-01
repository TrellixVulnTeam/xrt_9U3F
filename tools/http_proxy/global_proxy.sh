#!/bin/sh

on() {
  JQ_EXEC=`which jq`
  FILE_PATH=$1

  HOST=$(cat ${FILE_PATH} | ${JQ_EXEC} .proxy.host | sed 's/\"//g')
  PORT=$(cat ${FILE_PATH} | ${JQ_EXEC} .proxy.port | sed 's/\"//g')
  PROXY=${HOST}:${PORT}

  export proxy=${PROXY}
  export http_proxy=${PROXY}
  export https_proxy=${PROXY}
  export ftp_proxy=${PROXY}
}

off() {
  unset proxy
  unset http_proxy
  unset https_proxy
  unset ftp_proxy
}

status() {
  echo proxy=${proxy}
  echo http_proxy=${http_proxy}
  echo https_proxy=${https_proxy}
  echo ftp_proxy=${ftp_proxy}
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

