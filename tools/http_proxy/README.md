Create Local http(s) Proxy by PAC file,so we can use pac files to touch git reps such as 'chromium.googlesource.com'  

Usage:  
1.Start local pac proxy server  
  > sh run.sh [config.json]

if you want set git proxy,as follow:  
  > sh git_proxy.sh [on|off|status]

if you want set curl proxy,as follow:  
  You can make a alias in your ~/.bashrc file :  
  alias curl="curl -x <proxy_host>:<proxy_port>"

  Another solution is to use (maybe the better solution) the ~/.curlrc file (create it if it does not exist) :  
  > proxy = <proxy_host>:<proxy_port>

if you want set python urllib2 proxy, as follow:  
        add ~/.bashrc  
  > export http_proxy=<proxy_host>:<proxy_port>  
  > export https_proxy=<proxy_host>:<proxy_port>
