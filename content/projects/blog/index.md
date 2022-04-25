---
layout:         "project"
title:          "Blog"
# date:           2022-03-25
author:         "jifan"
math:           true
summary:        "Why and how did I build this blog."
description:    "Why and how did I build this blog."
tags:
    - Web
cover:
    image: "projects/blog/assets/cover.jpg"
    # can also paste direct link from external site
    # ex. https://i.ibb.co/K0HVPBd/paper-mod-profilemode.png
    alt: "<alt text>"
    caption: "<text>"
    relative: true # To use relative path for cover image, used in hugo Page-bundles
    hidden: true

---

Yes, indeed. This is not my first blog. You may find that there are some posts publised in quite a few years ago, followed by a long gap. Perhaps there will be an opportunity to tell you the story of that time ……

# 1. My Previous Blogs

## 1.1 A taste of **WordPress**

[WordPress](https://wordpress.com/) was, and probably still is, the most popular blog hosting platform in the world. It's almost entirely code-free to start a blog with WordPress. Unfortunately, I wasn't an enthusiastic blogger then, so [this product of a whim](https://mythistledown.wordpress.com/) was left unused as soon as it was built.

{{< figure align=center src="./assets/my_first_empty_blog.png" width="70%" caption="Figure 1. My first but empty blog">}}

## 1.2 Blogging with **Jekyll** on a **NGINX** Server

By the time I rediscovered my passion for blogging, [Jekyll](https://jekyllrb.com/), as a static site generator, has already caught on. Detailed documentation, rich themes, and an active community were my reasons for choosing it.

After installing the prerequisites, the entire setup process can be divided into 3 poarts.
- **Server setting**: 
    - Nginx installation, configuration and deployment.
        ```nginx
        server {
            listen       80 ;
            server_name  _ localhost my-thistledown.com www.my-thistledown.com ;
            location = /webhook {
                proxy_pass http://127.0.0.1:3001/webhook;
            }
            
        #    return 301 https://www.my-thistledown.com$request_uri;
        }
        server {
            listen 443;
            server_name my-thistledown.com;
            return 301 https://www.my-thistledown.com$request_uri;
        }
        server {
            listen 443 default_server ssl;
            server_name www.my-thistledown.com;

            ssl          on;
            ssl_certificate   /etc/nginx/ssl/my-thistledown.com/1692217_my-thistledown.com.pem;
            ssl_certificate_key  /etc/nginx/ssl/my-thistledown.com/1692217_my-thistledown.com.key;
            ssl_session_timeout 5m;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            ssl_ciphers AESGCM:ALL:!DH:!EXPORT:!RC4:+HIGH:!MEDIUM:!LOW:!aNULL:!eNULL;
            ssl_prefer_server_ciphers on;


            root /usr/share/nginx/html;
            index index.html index.htm;

            location / {
                root /usr/share/nginx/html;
                index index.html;
            }


            error_page  404              /404.html;

            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   /usr/share/nginx/html;
            }
        }
        ```
    - Open specified ports (80, 443) and resolve my domain name to the server IP address.
- **Jekyll site building**:
    - Create a new Jekyll site and add some posts.
    - Build the site and output a static site to the nginx server's root directory (in may case, `/usr/share/nginx/html`), located by the nginx configuration file.
- **Automated deployment**:
    - **Webhooks** allow me to subscribe to certain events on GitHub.com.
    - Every time I write a post or modify the blog locally and synchronize with the remote repository via `git push`, a HTTP POST payload will be sent to the webhook's configured URL.
    - With the help of [github-webhook-handler](https://github.com/rvagg/github-webhook-handler), I can receive and verifying webhook requests from GitHub and execute the local script to pull the remote repositry and rebuild the site.

# 2. This New **Hugo**-based Blog
As it claims, [Hugo](https://gohugo.io/) makes building websites fun and fast. Similarly, the website building process is divided into the following stages:
- **Hugo site building**:
    - Install hugo, create a new site and add a theme, with a blistering speed💨.
    - Add my old posts. I was impressed by the built-in [LiveReload](https://github.com/livereload/livereload-js), which saved me from repeatedly refreshing the page during development to see content changes, as I did with Jekyll.
- **GitHub Pages deployment**:
    - Compared to my last site, I have to admit that [GitHub Pages](https://pages.github.com/) is a more time- and money-saving way to host a personal blog.
    - Configuring a custom domain for my GitHub Pages site.
- **Add my own content**:
    - Custom some CSS styles of the original theme.
    - Add content and front matther to page templates.
    - Updates:
        - [x] ~~Support $\KaTeX$~~ (2022.03.29).
        - [x] ~~Add a projects listing page and change the style of cover image~~ (2022.04.02).
        - [ ] Custom syntax highlighting style and make code block collapsible.
    <!-- Learn from https://github.com/dillonzq/LoveIt -->


# 3. What I Talk About When I Talk About Blog

The process of rebooting my blog not only helped me pick up some of the front-end knowledge I had forgotten, but also provided me with a new window of expression.

Today, building such a site is no longer a complex project. From WordPress to Jekyll and now Hugo. I'm happy to embrace these new technologies that help us implement our ideas faster and more easily.
