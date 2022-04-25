---
layout:         "project"
title:          "Tiny Web Server: Problems Encountered"
date:           2022-04-03
author:         "Jifan"
math:           true
# summary:        "A C++ lightweight web server based on Linux epoll."
# description:    "A C++ lightweight web server based on Linux epoll."
---

# 1. `MySQL Error` in log file
Server stopped immediately after running `./server` in shell, and output an error `MySQL Error` in log file.
- **Find the source of the error**: Although the error log is fairly vague, it's not difficult to find out that it was thrown by the function `connection_pool::init` in the file `CGImysql/sql_connection_pool.cpp`.
    - `mysql_init()`: return an initialized `MYSQL*` handler (i.e. a MYSQL object suitable for `mysql_real_connect()`), or `NULL` in case of insufficient memory.
    - `mysql_real_connect()`: return a `MYSQL*` connection handler if the connection was successful, `NULL` if the connection was unsuccessful.
    - It's no doubt that detailed error output helps us to locate the problem.
    ```c++
    // Note: due to the refactoring of the project, this code no longer corresponds to 
    // the existing one, but the idea of solving this problem remains similar.
    void connection_pool::init(string url, string User, string PassWord, string DBName, int Port, int MaxConn, int close_log) {
        m_url = url;
        m_Port = Port;
        m_User = User;
        m_PassWord = PassWord;
        m_DatabaseName = DBName;
        m_close_log = close_log;

        for (int i = 0; i < MaxConn; i++) {
            MYSQL* con = NULL;
            con = mysql_init(con);

            if (con == NULL) {
                // If `mysql_init()` return NULL, print corresponding error log.
                // LOG_ERROR("MySQL Error");
                LOG_ERROR("MySQL Error: `mysql_init()` return NULL, maybe there was insufficient memory to allocate a new object.");
                exit(1);
            }
            MYSQL* temp = con;
            con = mysql_real_connect(con, url.c_str(), User.c_str(), PassWord.c_str(), DBName.c_str(), Port, NULL, 0);

            if (con == NULL) {
                // If `mysql_real_connect()` return NULL, print correspnding error log.
                // LOG_ERROR("MySQL Error");
                string err_info( mysql_error(temp) );
                err_info = (string("MySQL Error [errno=") + std::to_string(mysql_errno(temp)) + string("]: ") + err_info);
                LOG_ERROR( err_info.c_str() );
                exit(1);
            }
            connList.push_back(con);
            ++m_FreeConn;
        }

        reserve = sem(m_FreeConn);
        m_MaxConn = m_FreeConn;
    }
    ```
- **Identify error type**: after modifying the log output style, the following error ocurrs:
    ```plaintext
    2022-04-03 19:30:29.360109 [erro]: MySQL Error [errno=1045]: Access denied for user 'USER_NAME'@'localhost' (using password: YES)
    ```

- **Solutions**:
    - Check whether the database information in the `main.cpp` file is correct, including `USER_NAME`, `PASSWORD`, and `DATABASE_NAME`.
    - Verify that user `USER_NAME` has access privileges to the target database `DATABASE_NAME`.