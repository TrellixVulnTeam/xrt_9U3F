#!/bin/bash

start() {
  git config --global http.proxy http://127.0.0.1:8080
  git config --global https.proxy https://127.0.0.1:8080
}

stop() {
  git config --global --unset http.proxy
  git config --global --unset https.proxy  
}

status() {
  git config --get --global http.proxy
  git config --get --global https.proxy
}

case "$1" in
  'on')
      start
      ;;
  'off')
      stop
      ;;
  'status')
      status
      ;;
  *)
      echo
      echo "Usage: $0 { on | off | status }"
      echo
      exit 1
      ;;
esac

exit 0