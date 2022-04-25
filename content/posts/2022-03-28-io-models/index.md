---
layout:     post
title:      "I/O multiplexing: select, poll and epoll"
date:       2022-03-28
author:     "Jifan"
math:       false
draft:      true
tags:
    - Linux
    - I/O
description: ""
---
> **TL,DR.** 
> - The `select()` and `poll()` are system calls to monitor file descriptors. 
> - And the *epoll* is a Linux-specified API to implement I/O multiplexing with higher performance when it comes to large numbers of file descriptors.

# 1. Why not blocking I/O?

Under the convensional file I/O model, a process performs I/O on just one file descriptor, named ***fd***, at a time, and each I/O system call blocks until the data is transferred. For example, when reading from the pipe,
- a `read()` call normally blocks if no data is currently persent in the pipe. And,
- a `write()` call blocks if there is insufficient space in the pipe to hold the data to be written.

It's no doubt that the traditional blocking I/O model is already stretched when we need to monitor multiple file descriptors, or avoid blocking the current process if I/O is not possible on a file descriptor.

There are two direct approaches to partially address these needs: 
- Nonblocking I/O.
- Use of multiple processes or threads.

Nonblocking I/O allows us to periodically check ("poll") whether I/O is possible.
For expample, we can make an input file descriptor nonblocking, and then periodically performing nonblocking reads. If we need to monitor multiple file descriptor, then we mark them all nonblocking, and poll each of them in turn. 
However, polling in this manner is usually undesirable. If polling is done only infrequently, then the latency before an application responds to an I/O event may be unacceptably long; on the other hand, polling in a tight loop wastes CPU time.

<!-- One common idea is to create child processes or child threads to perform the I/O.  -->
If we need to handle I/O on multiple file descriptors, we can create one child process or thread for each descriptor. To do so, however, an inter-process/thread communication mechanism is needed to inform the parent about the status of the I/O operations, which demanding more resources and can lead to programming difficulties.

Fortunately, modern Linux provides the following alternative I/O models.

# I/O multiplexing: `select()` & `poll()`

**I/O multiplexing** allows a process to simultaneously monitor multiple file descriptors to find out whether I/O is possible on any of them. The `select()` and `poll()` system calls perform I/O multiplexing.

# Signal-driven I/O

**Signal-driven I/O** is a technique whereby a process requests that the kernel send it a signal when input is avaiable or data can be written on a specified file descriptor. The process can then carry on performing other activities, and is notified when I/O becomes possible via receipt of the signal. When monitoring large numbers of file descriptors, signal-driven I/O provides significantly better performance than `select()` and `poll()`.

# The Linux-specific *epoll* API
**The *epoll* API** is a Linux-specifc feature that first appeared in Linux 2.6 (?). Like the I/O multiplexing APIs, the *epoll* API allows a process to monitor multiple file descriptors to see if I/O is possible on any of them. Like signal-driven I/O, the *epoll* API provides much better performance when monitoring large numbers of file descriptors.