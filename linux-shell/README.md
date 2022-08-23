- # linux-shell

- [常用指令](#常用指令)
  - [字符串查找替换](#字符串查找替换)
  - [字符串截取](#字符串截取)
  - [文件大小及排序](#文件大小及排序)
- [示例与实践](#示例与实践)
  - [修改网卡名称](#修改网卡名称)

## 常用指令
### 字符串查找替换
原理
`${parameter//pattern/string}`
用string来替换parameter变量中所有匹配的pattern

示例
```shell
string="hello,shell,split,test"  

# string中的“,”替换成空格后赋值给array 就成了数组赋值
array=(${string//,/ })  

for var in ${array[@]}
do
    echo $var
done 
```

输出结果
```shell
hello
shell
split
test
```

### 字符串截取

语法  
- 从字符串左边开始计数 `${string: start :length}`  
- 从右边开始计数 `${string: 0-start :length}`
- 使用 # 号截取右边字符 `${string#*chars}`
- 使用 % 截取左边字符 `${string%chars*}`

| 格式 | 说明 |
| ---- | ---- | 
| ${string: start :length} | 从 string 字符串的左边第 start 个字符开始，向右截取 length 个字符。 | 
| ${string: start}| 从 string 字符串的左边第 start 个字符开始截取，直到最后。 | 
| ${string: 0-start :length} | 从 string 字符串的右边第 start 个字符开始，向右截取 length 个字符。| 
| ${string: 0-start} | 从 string 字符串的右边第 start 个字符开始截取，直到最后。| 
|  ${string#*chars} | 从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。| 
| ${string##*chars} | 从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。| 
|  ${string%*chars} |  从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。| 
| ${string%%*chars}| 从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。| 

示例
```shell
url="c.biancheng.net"
echo ${url: 2: 9}     # 结果为biancheng

url="c.biancheng.net"
echo ${url: 0-13: 9}   # 结果为biancheng

url="http://c.biancheng.net/index.html"
echo ${url#*/}    #结果为 /c.biancheng.net/index.html
echo ${url##*/}   #结果为 index.html

url="http://c.biancheng.net/index.html"
echo ${url%/*}  #结果为 http://c.biancheng.net
echo ${url%%/*}  #结果为 http:
```

### `du`文件大小及排序

Linux du （英文全拼：disk usage）命令用于显示目录或文件的大小。  
du 会显示指定的目录或文件所占用的磁盘空间。  

常用参数  
- -h或--human-readable 以K，M，G为单位，提高信息的可读性。  
- --max-depth=<目录层数> 超过指定层数的目录后，予以忽略。  
- -s或--summarize 仅显示总计。  

显示总计
```shell
du -sh *
```
输出结果
```shell
0	bin
160M	boot
11G	data
0	dev
39M	etc
12K	home
0	lib
0	lib64
328K	log
16K	lost+found
4.0K	media
8.0K	mnt
2.2G	opt
```

只显示一级目录
```shell
du -h --max-depth=1 *
```
输出结果
```shell
0	bin
7.8M	boot/grub2
6.0K	boot/efi
5.0K	boot/grub
13K	boot/lost+found
160M	boot
1.1M	data/flowdata
412K	data/allow-list
24K	data/configuration
852K	data/rules
6.1G	data/log
728K	data/redis
28K	data/network_attack
44K	data/audit
104M	data/report
4.0K	data/socket
60K	data/self-proto
3.0G	data/coredump
512M	data/supervisord
4.0K	data/mysql-outputs
68M	data/pcap
409M	data/mysql
16K	data/engine_conf
16K	data/lost+found
11G	data
```

输出结果并排序
```shell
du -h --max-depth=1 /data | sort -nr
```

输出结果
```shell
852K	/data/rules
728K	/data/redis
512M	/data/supervisord
412K	/data/allow-list
409M	/data/mysql
104M	/data/report
68M	/data/pcap
60K	/data/self-proto
44K	/data/audit
28K	/data/network_attack
24K	/data/configuration
16K	/data/lost+found
16K	/data/engine_conf
11G	/data/
6.1G	/data/log
4.0K	/data/socket
4.0K	/data/mysql-outputs
3.0G	/data/coredump
1.1M	/data/flowdata
```

### [grep](grep.md)  
> grep 更适合单纯的查找或匹配文本  
> sed 更适合编辑匹配到的文本  
> awk 更适合格式化文本，对文本进行较复杂格式处理  
> 
### [sed](sed.md)  

### [awk](awk.md)  

### [find](find.md)

### `crontab`定时任务  
[crontab在线](https://tool.lu/crontab/)  
linux内置的cron进程能帮我们实现这些需求，cron搭配shell脚本，非常复杂的指令也没有问题。  

我们经常使用的是crontab命令是cron table的简写，它是cron的配置文件，也可以叫它作业列表，我们可以在以下文件夹内找到相关配置文件。  

- /var/spool/cron/ 目录下存放的是每个用户包括root的crontab任务，每个任务以创建者的名字命名  
- /etc/crontab 这个文件负责调度各种管理和维护任务。  
- /etc/cron.d/ 这个目录用来存放任何要执行的crontab文件或脚本。
- 我们还可以把脚本放在`/etc/cron.hourly`、`/etc/cron.daily`、`/etc/cron.weekly`、`/etc/cron.monthly`目录中，让它每小时/天/星期、月执行一次。  

语法
```shell
crontab [-u username]　　　　//省略用户表表示操作当前用户的crontab
    -e      (编辑工作表)
    -l      (列出工作表里的命令)
    -r      (删除工作作)
``` 

我们用crontab -e进入当前用户的工作表编辑，是常见的vim界面。每行是一条命令。  
crontab的命令构成为 时间+动作，其时间有`分`、`时`、`日`、`月`、`周`五种，操作符有

- * 取值范围内的所有数字
- / 每过多少个数字
- - 从X到Z
- ，散列数字 

示例
```shell
# 每1分钟执行一次myCommand
* * * * * myCommand

# 每小时的第3和第15分钟执行
3,15 * * * * myCommand

# 在上午8点到11点的第3和第15分钟执行
3,15 8-11 * * * myCommand

# 每晚的21:30重启smb
30 21 * * * /etc/init.d/smb restart

# 每周六、周日的1 : 10重启smb
10 1 * * 6,0 /etc/init.d/smb restart
```

```shell
$ crontab -l
0 0 * * * /usr/local/audit/delete_log.sh 
```

## 示例与实践  
### 修改网卡名称  
```shell
# 查看网卡设备信息
$ ll /sys/class/net/ | awk '/\/devices\/pci\S+/'
lrwxrwxrwx 1 root root 0 8月  24 06:46 eth0 -> ../../devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0
lrwxrwxrwx 1 root root 0 8月  24 06:46 eth1 -> ../../devices/pci0000:00/0000:00:1c.5/0000:03:00.0/net/eth1
lrwxrwxrwx 1 root root 0 8月  24 06:46 eth2 -> ../../devices/pci0000:00/0000:00:1c.6/0000:04:00.0/net/eth2
lrwxrwxrwx 1 root root 0 8月  24 06:46 eth3 -> ../../devices/pci0000:00/0000:00:1c.7/0000:05:00.0/net/eth3
lrwxrwxrwx 1 root root 0 8月  24 06:46 eth4 -> ../../devices/pci0000:00/0000:00:1d.0/0000:06:00.0/net/eth4
lrwxrwxrwx 1 root root 0 8月  24 06:46 eth5 -> ../../devices/pci0000:00/0000:00:1d.1/0000:07:00.0/net/eth5

# 写入规则
$ cat /etc/udev/rules.d/99-persistent-net.rules
SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*", DEVPATH=="/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/*", NAME="eth0"
SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*", DEVPATH=="/devices/pci0000:00/0000:00:1c.5/0000:03:00.0/net/*", NAME="eth1"
SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*", DEVPATH=="/devices/pci0000:00/0000:00:1c.6/0000:04:00.0/net/*", NAME="eth2"
SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*", DEVPATH=="/devices/pci0000:00/0000:00:1c.7/0000:05:00.0/net/*", NAME="eth3"
SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*", DEVPATH=="/devices/pci0000:00/0000:00:1d.0/0000:06:00.0/net/*", NAME="eth4"
SUBSYSTEM=="net",ACTION=="add",DRIVERS=="?*", DEVPATH=="/devices/pci0000:00/0000:00:1d.1/0000:07:00.0/net/*", NAME="eth5"
```

脚本实现
```shell
# 样本
pcis=$(ls -l /sys/class/net/ | grep -Eo '/devices/pci.+net')

# 遍历结果
pciArray=(${pcis// / })   # 也可以不用
for pci in ${pciArray[@]}
do
    echo $pci
done
```


