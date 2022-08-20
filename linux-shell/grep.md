# grep

Linux grep 命令用于查找文件里符合条件的字符串。

grep 指令用于查找内容包含指定的范本样式的文件，如果发现某文件的内容符合所指定的范本样式，预设 grep 指令会把含有范本样式的那一列显示出来。若不指定任何文件名称，或是所给予的文件名为 -，则 grep 指令会从标准输入设备读取数据。  

语法
```shell
grep [-abcEFGhHilLnqrsvVwxy][-A<显示行数>][-B<显示列数>][-C<显示列数>][-d<进行动作>][-e<范本样式>][-f<范本文件>][--help][范本样式][文件或目录...]
```

help信息
```shell
正则表达式选择与解释:
  -E, --extended-regexp     PATTERN 是一个可扩展的正则表达式(缩写为 ERE)
  -F, --fixed-strings       PATTERN 是一组由断行符分隔的定长字符串。
  -G, --basic-regexp        PATTERN 是一个基本正则表达式(缩写为 BRE)
  -P, --perl-regexp         PATTERN 是一个 Perl 正则表达式
  -e, --regexp=PATTERN      用 PATTERN 来进行匹配操作
  -f, --file=FILE           从 FILE 中取得 PATTERN
  -i, --ignore-case         忽略大小写
  -w, --word-regexp         强制 PATTERN 仅完全匹配字词
  -x, --line-regexp         强制 PATTERN 仅完全匹配一行
  -z, --null-data           一个 0 字节的数据行，但不是空行

Miscellaneous:
  -s, --no-messages         suppress error messages
  -v, --invert-match        select non-matching lines
  -V, --version             display version information and exit
      --help                display this help text and exit

输出控制:
  -m, --max-count=NUM       NUM 次匹配后停止
  -b, --byte-offset         输出的同时打印字节偏移
  -n, --line-number         输出的同时打印行号
      --line-buffered       每行输出清空
  -H, --with-filename       为每一匹配项打印文件名
  -h, --no-filename         输出时不显示文件名前缀
      --label=LABEL         将LABEL 作为标准输入文件名前缀
  -o, --only-matching       show only the part of a line matching PATTERN
  -q, --quiet, --silent     suppress all normal output
      --binary-files=TYPE   assume that binary files are TYPE;
                            TYPE is 'binary', 'text', or 'without-match'
  -a, --text                equivalent to --binary-files=text
  -I                        equivalent to --binary-files=without-match
  -d, --directories=ACTION  how to handle directories;
                            ACTION is 'read', 'recurse', or 'skip'
  -D, --devices=ACTION      how to handle devices, FIFOs and sockets;
                            ACTION is 'read' or 'skip'
  -r, --recursive           like --directories=recurse
  -R, --dereference-recursive
                            likewise, but follow all symlinks
      --include=FILE_PATTERN
                            search only files that match FILE_PATTERN
      --exclude=FILE_PATTERN
                            skip files and directories matching FILE_PATTERN
      --exclude-from=FILE   skip files matching any file pattern from FILE
      --exclude-dir=PATTERN directories that match PATTERN will be skipped.
  -L, --files-without-match print only names of FILEs containing no match
  -l, --files-with-matches  print only names of FILEs containing matches
  -c, --count               print only a count of matching lines per FILE
  -T, --initial-tab         make tabs line up (if needed)
  -Z, --null                print 0 byte after FILE name

文件控制:
  -B, --before-context=NUM  打印以文本起始的NUM 行
  -A, --after-context=NUM   打印以文本结尾的NUM 行
  -C, --context=NUM         打印输出文本NUM 行
  -NUM                      same as --context=NUM
      --group-separator=SEP use SEP as a group separator
      --no-group-separator  use empty string as a group separator
      --color[=WHEN],
      --colour[=WHEN]       use markers to highlight the matching strings;
                            WHEN is 'always', 'never', or 'auto'
  -U, --binary              do not strip CR characters at EOL (MSDOS/Windows)
  -u, --unix-byte-offsets   report offsets as if CRs were not there
                            (MSDOS/Windows)

‘egrep’即‘grep -E’。‘fgrep’即‘grep -F’。
直接使用‘egrep’或是‘fgrep’均已不可行了。
若FILE 为 -，将读取标准输入。不带FILE，读取当前目录，除非命令行中指定了-r 选项。
如果少于两个FILE 参数，就要默认使用-h 参数。
如果有任意行被匹配，那退出状态为 0，否则为 1；
如果有错误产生，且未指定 -q 参数，那退出状态为 2。
```

## 正则表达`-E`
`-E, --extended-regexp     PATTERN 是一个可扩展的正则表达式(缩写为 ERE)`  
```shell
$ ls -l /sys/class/net/
总用量 0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 docker0 -> ../../devices/virtual/net/docker0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 enp1s0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net/enp1s0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 enp2s0 -> ../../devices/pci0000:00/0000:00:1c.5/0000:02:00.0/net/enp2s0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 enp3s0 -> ../../devices/pci0000:00/0000:00:1c.6/0000:03:00.0/net/enp3s0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 enp4s0 -> ../../devices/pci0000:00/0000:00:1c.7/0000:04:00.0/net/enp4s0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 enp5s0 -> ../../devices/pci0000:00/0000:00:1d.0/0000:05:00.0/net/enp5s0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 enp6s0 -> ../../devices/pci0000:00/0000:00:1d.1/0000:06:00.0/net/enp6s0
lrwxrwxrwx. 1 root root 0 7月  22 16:20 lo -> ../../devices/virtual/net/lo
```

使用正则表达式`-E`,并且只显示匹配的内容`-o`  
`-o, --only-matching       show only the part of a line matching PATTERN`  
```shell
$ ls -l /sys/class/net/ | grep -Eo '/devices/pci.+net'
/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net
/devices/pci0000:00/0000:00:1c.5/0000:02:00.0/net
/devices/pci0000:00/0000:00:1c.6/0000:03:00.0/net
/devices/pci0000:00/0000:00:1c.7/0000:04:00.0/net
/devices/pci0000:00/0000:00:1d.0/0000:05:00.0/net
/devices/pci0000:00/0000:00:1d.1/0000:06:00.0/net
```

