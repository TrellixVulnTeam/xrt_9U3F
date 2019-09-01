# Http Proxy

Create Local http(s) Proxy by PAC file

Usage:  
1.Start local pac proxy server  
  > sh run.sh [config.json]

2.Set proxy  
if you want to set global proxy, as follow:  
  > source global_proxy.sh [on|off] [config.json]
  > sh global_proxy.sh status

if you want to set git proxy, as follow:  
  > sh git_proxy.sh [on|off|status] [config.json]  

so we can touch git reps such as 'chromium.googlesource.com'  
