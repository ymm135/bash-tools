- # linux-shell
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


> grep 更适合单纯的查找或匹配文本  
> sed 更适合编辑匹配到的文本  
> awk 更适合格式化文本，对文本进行较复杂格式处理  
- ### [grep](grep.md)  
- ### [sed](sed.md)  
- ### [awk](awk.md)  

### 示例与实践  
## 修改网卡名称  
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
pciArray=(${pcis// / }) 
for pci in ${pciArray[@]}
do
    echo $pci
done
```


