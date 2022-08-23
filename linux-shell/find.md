# find

## 通过时间查找文件
```shell
-daystart
              Measure times (for -amin, -atime, -cmin, -ctime, -mmin, and -mtime) from the beginning of today rather than from 24 hours ago.  This option only affects tests which appear later on the command line.
-mtime n
              File's data was last modified n*24 hours ago.  See the comments for -atime to understand how rounding affects the interpretation of file modification times.
```

查找7天之前的文件并删除,文件格式如`2022_08_03_server_error.log`
```shell
# 无法匹配
find $PWD -mtime +7 -name "\d{4}_\d{2}_\d{2}.*" -exec rm -Rf {} \;

# 可以匹配
find $PWD -mtime +7 -name "[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_*.log" -exec rm -Rf {} \;
```

为什么无法使用常用的正则表达式呢?
```shell
-regex pattern
              File name matches regular expression pattern.  This is a match on the whole path, not a search.  For example, to match a file named `./fubar3', you can use the regular expression `.*bar.' or `.*b.*3', but not
              `f.*r3'.  The regular expressions understood by find are by default Emacs Regular Expressions, but this can be changed with the -regextype option.
```

> 正则表达式是``
