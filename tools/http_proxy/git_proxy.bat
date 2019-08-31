
IF "%1"=="on" (
  git config --global http.proxy http://127.0.0.1:8080
  git config --global https.proxy https://127.0.0.1:8080
) ELSE IF "%1"=="off" (
  git config --global --unset http.proxy
  git config --global --unset https.proxy  
) ELSE IF "%1"=="status" (
  git config --get --global http.proxy
  git config --get --global https.proxy
) ELSE (
    echo "Usage: $0 { on | off | status }"
    exit 1
)

exit 0