---
layout:     post
title:      "A Primer on Web Server"
date:       2022-03-02
author:     "Jifan"
math:       false
tags:
    - Web
description: ""
---

> Before starting the [TinyWebServer](../../projects/tiny-web-server/) project, I took a quick look at what a web server is. This article is a general summary of it, based on my current basic understanding.


# 1. What is a web server?

The term **web server** can refer to software or underlying hardware.
- On the hardware side, a web server is a computer that:
    - stores web server software and a website's component files (e.g., HTML documents, images, CSS stylesheets and JavaScript files).
    - connects to the Internet and supports physical data interchange with other devices connected to the web.
- On the software side, a web server includes several parts that control how web users access hosted files.
    - At a minimum, this is an *HTTP server*. An HTTP server is a software that understands URLs (web address) and HTTP (the network protocal created to dsitribute web content).
    - An HTTP server can be accessed through the domain names of the websites it stores. Besides HTTP, web servers can also support SMTP and FTP, used for email, file transfer and storage.
    - It can deliver the content of hosted websites to the end usrer's device, and also can accept and stores resources sent from the user agent if configured to do so.

{{< figure align=center src="./assets/web-server.svg" width="70%" caption="Figure 1. A basic Client-Server model. (*Image source: developer.mozilla.org*)">}}

Typically, web servers are classified as static and dynamic.

- A static web server, or stack, consists of a computer (hardware) with an HTTP server (software). We call it "static" because the server sends its hosted files as-is to your browser.
- A dynamic web server consists of a static web server plus extra software, most commonly an application server and a database. We call it "dynamic" because the application server updates the hosted files before sending content to your browser via the HTTP server.

Currently, the most used Web Servers in the world are [Apache HTTP Server](https://httpd.apache.org), [Nginx](https://www.nginx.com), [Microsoft-IIS](https://openresty.org/), [OpenResty](https://openresty.org/), etc.


# 2. How a client and server communicate?

Normally, a client makes HTTP requests to a server. 
- The server responds to the client's HTTP requests. And the server and also populate data into a client cache, in advance of it being requested, through a mechanism called a server push.
- When requesting a file via HTTP, the client must provice the file's URL.
- The web server must answer every HTTP request, at least with an error message.

On a web server, the HTTP server is responsible for processing and answering incoming requests.
- Upon receiving a request, an HTTP server first checks if the requested URL matches an existing file.
- If so, the web server sends the file content back to the browser. If not, an appicatoin server builds the necesary file.
- If neither process is possible, the web server returns an error message to the browser, most commonly `404 Not Found` (indicates that the server cannot find the requested resource).


# 3. Performances
To improve the user experience (on client / browser side), a web server should reply quickly (as soon as possible) to client requests; unless content response is throttled (by configuration) for some type of files (e.g. big or huge files), also returned data content should be sent as fast as possible (high transfer speed).

## 3.1 Performance metrics
For web server software, main key performance metrics usually are at least the following ones:
- number of requests per second (RPS); It's similar to QPS (queries per second), depending on HTTP version and configuration, type of HTTP requests and other operating conditions;
- number of connections per second (CPS), is the number of connections per second accepted by web server;
- network latency + response time for each new client request;
- throughput of responses, in bytes per second.

## 3.2 Benchmarking
Web server benchmarking is the process of estimating a web server performance in order to find if the server can serve sufficiently high workload. The measurements must be performed under a varying load of clients and requests per client.

Load testing (stress/performance testing) a web server can be performed using automation/analysis tools.


> **Refrences**:
> 1. [What is a web server? - Learn web development | MDN](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/What_is_a_web_server)
> 2. [Web server - Wikipedia](https://en.wikipedia.org/wiki/Web_server)
