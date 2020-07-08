## Command Line URL viewer

* 读作 see-URL，也有客户端URL工具的意思
* -X, --request COMMAND  Specify request command to use 参数指定 HTTP 请求的方法（默认 GET 请求）
  * 不加任何参数，就是GET请求（-X GET），默认输出到标准输出
* -d, --data DATA     HTTP POST data (H) 发送 POST 请求体（此时可省 -X POST）
  * 且都会加上头 `Content-Type : application/x-www-form-urlencoded`
  * 如果要发送 json，则应 `-H "Content-Type: application/json' https://google.com/login"`
  * 键值对之间用 **&** 连接 `-d"a=1&b=2"`
  * 也可以指定多个分开来 `-d"a=1" -d"b=2"`
  * 也可以指定文件 `-d"@data.txt"`
  * `curl -X POST -d "a=1&b=2" url`
* --data-raw DATA  HTTP POST data, '@' allowed (H)
* --data-ascii DATA  HTTP POST ASCII data (H)
* --data-binary DATA  HTTP POST binary data (H)
* --data-urlencode DATA  HTTP POST data url encoded (H) （对请求体进行 URL 编码）
* -H, --header LINE   Pass custom header LINE to server (H)  指定请求头
  * `curl -H 'Accept-Language: en-US' -H 'Secret-Message: xyzzy' https://google.com`
  * **发送JSON**：`curl -d '{"login": "emma", "pass": "123"}' -H 'Content-Type: application/json' https://google.com/login`
* -e, --referer Referer URL (H) 指定 from_url（相当于添加头 Referer）
* -A, --user-agent STRING  Send User-Agent STRING to server (H) 指定用户代理（相当于添加头 User-Agent）
  * `curl -A '' url` 也可以清空代理
* -b, --cookie STRING/FILE  Read cookies from STRING/FILE (H) 发送 cookie（相当于添加头 Cookie）
  * 键值对用分号 **;** 连接 `-b"a=1;b=2"`
  * 也可以指定 cookie 文件 `-bcookie.txt` （由 -c 获取）
* -c, --cookie-jar FILE  Write cookies to FILE after operation (H) 获取 cookie 文件
  * `-c cookie.txt` 保存 cookie 到文件
* -C, --continue-at OFFSET（Resumed transfer OFFSET）断点续传
  * 偏移量是以字节为单位的整数
  * 偏移量指定为 - 表示自动推测
* -F, --form CONTENT  Specify HTTP multipart POST data (H) 发送二进制
  * `-F"file=@photo.png"`（相当于添加头 `Content-Type: multipart/form-data`）
  * `-F"file=@photo.png;type=image/png"`
    * 指定 MIME 类型为 `image/png`，否则默认为 `application/octet-stream`
  * `-F"file=@photo.png;filename=me.png"` 指定文件名（服务器接到的文件名为 me.png）
* -G, --get Send the -d data with a HTTP GET (H) 把 POST 的请求体改为 GET 的查询字符串
* -i, --include Include protocol headers in the output (H/F) 打印服务器响应头
* -I, --head Show document info only 只打印服务器响应头（向服务器发送 HEAD 请求，但是 -X HEAD 不行）
* -k, --insecure Allow connections to SSL sites without certs (H) 不检查服务器的 SSL 证书是否正确（跳过 SSL 检测）
* -L, --location Follow redirects (H) 自动跳转重定向（默认不重定向）
* --limit-rate RATE  Limit transfer speed to RATE 限制 HTTP 请求和回应的带宽（模拟慢网速的环境）
  * `curl --limit-rate 200k https://google.com` 将带宽限制在每秒 200K 字节
* -o, --output FILE   Write to FILE instead of stdout 输出到指定文件（默认输出到标准输出，相当于下载文件 wget）
* -O, --remote-name   Write output to a file named as the remote file 将服务器回应保存成文件，并将 URL 的最后部分当作文件名
  * `curl -O https://www.example.com/foo/bar.html` 保存为 bar.html
* -s, --silent Silent mode (don't output anything)  不输出错误和进度信息（但是输出正常信息）
  * `curl -s -o /dev/null https://google.com` 不输出任何信息
* -S, --show-error    Show error. With -s, make curl show errors when they occur
* -u, --user USER[:PASSWORD]  Server user and password
  * `curl -u 'bob:12345' https://google.com/login` （相当于头 `Authorization: Basic Ym9iOjEyMzQ1`）
  * `curl https://bob:12345@google.com/login` 也可直接把帐号密码放 url 里
  * 也可省略密码，然后手动输入
* -v, --verbose Make the operation more talkative 输出通信的整个过程，用于调试
* --trace FILE Write a debug trace to FILE 输出更详细的信息（原始二进制信息）
  * **-** 表示标准输出这个文件（通用约定了）
* --trace-ascii FILE  Like --trace, but without hex output 输出更详细的信息（无二进制信息）
* --trace-time    Add time stamps to trace/verbose output
* -x, --proxy [PROTOCOL://]HOST[:PORT]  Use proxy on given port 指定代理（代理协议可省，默认为 HTTP）
  * `curl -x socks5://james:cats@myproxy.com:8080 https://www.example.com`
* -T, --upload-file FILE  Transfer FILE to destination
* [curl网站开发指南 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2011/09/curl.html)
* [curl 的用法指南 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2019/09/curl-reference.html)
* [Introduction - Everything curl](https://app.gitbook.com/@curl-1/s/everything-curl/)

## wget

* Retrieve files via HTTP or FTP（不支持 HTTPS）
* 下载日志和进度被写入 stdout
* 下载的文件名默认和URL中的文件名会保持一致（-O 改名），如果本地有同名则报错
* -s|--spider（Spider mode - only check file existence）
* -c|--continue（Continue retrieval of aborted transfer）
* -q|--quiet（Quiet）
* -P DIR（Save to DIR，default .）
* -T SEC（Network read timeout is SEC seconds）
* -O|--output-document FILE，Save to FILE，'-' for stdout）（使用 -O 会强制替换）
* -U|--user-agent AGENT（Use STR for User-Agent header）
* --header 'header: value'
* -Y|--proxy on/off（Use proxy，'on' or 'off'）
* URL...（支持多个 URL 也就是下载多个文件）

## Secure Copy Program

* 语法：`scp source ... target`（指定远程目录或文件格式：`username@host:/path`）
  * 指定用户名，可能会输入密码（除非公钥登录）
  * 不指定用户名，要手动输入用户和密码
  * 如果是上传，source 是本地，target 是远程
  * 如果是下载，source 是远程，target 是本地
* -B： 使用批处理模式（传输过程中不询问传输口令或短语）
* -C： 允许压缩
* -p：保留原文件的修改时间，访问时间和访问权限
* -P port（指定端口默认22）
* -q： 不显示传输进度条
* -r： 递归复制整个目录
* -v：详细方式显示输出
* -c cipher： 以cipher将数据传输进行加密，这个选项将直接传递给ssh
* -F ssh_config： 指定一个替代的ssh配置文件，此参数直接传递给ssh
* -i identity_file： 从指定文件中读取传输时使用的密钥文件，此参数直接传递给ssh
* -l limit： 限定用户所能使用的带宽，以Kbit/s为单位
* source 可指定多个来源文件或文件夹
* target 指定目标文件或文件夹

```sh
# 上传文件
scp file user@ip:folder # 或 file
# 上传文件夹
scp -r folder user@ip:folder 

# 下载文件
scp user@ip:folder folder # 或 file
# 下载文件夹
scp -r user@ip:folder folder
```

* 如果设置了 ~/.ssh/config 那直接用简写即可

```sh
scp file ta:/folder/file
```

