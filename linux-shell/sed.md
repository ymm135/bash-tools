# sed
Linux sed 命令是利用脚本来处理文本文件。 
Sed 主要用来自动编辑一个或多个文件、简化对文件的反复操作、编写转换程序等。 

语法
```shell
sed [-hnV][-e<script>][-f<script文件>][文本文件]
```

参数说明
- `-e``<script>`或--expression=`<script>` 以选项中指定的script来处理输入的文本文件。  
- `-f``<script文件>`或--file=`<script文件>` 以选项中指定的script文件来处理输入的文本文件。  
- -h或--help 显示帮助。  
- -n或--quiet或--silent 仅显示script处理后的结果。  
- -V或--version 显示版本信息。  

动作说明
- a ：新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
- c ：取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
- d ：删除，因为是删除啊，所以 d 后面通常不接任何东东；
- i ：插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
- p ：打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～
- s ：取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正则表达式！例如 1,20s/old/new/g 就是啦！


## 打印/测试 `-n`
> p ：打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行～  


```shell
echo -e "11111\n22222\n333333\n" | sed -n '1,2p'
```

输出结果
```shell
11111
22222
```

## 替换`s`  

```shell
mnInfo="mn=12u"
echo -e 'EquipmentModel: "testmodel"' | sed -n "s/EquipmentModel: \"\w*\"/EquipmentModel: \"${mnInfo#*mn=}\"/p"
```

输出结果是`EquipmentModel: "12u"`  

> 如果使用sed -n '' 单引号，mnInfo变量无法使用  

如果替换文件
```shell
sed -i "s/EquipmentModel: \"\w*\"/EquipmentModel: \"${mnInfo#*mn=}\"/g" /path/to/file  
```

## 正则表达式

| 字符 | 含义 |
| -- | ----- |
| . | 匹配除换行符以外的任意字符 |
| \w | 匹配字母或数字或下划线 |
| \s | 任意的空白符(包括空格制表符换页符) |
| [0-9] | 任意0到9中数字 |
| [a-zA-Z] | 26个英文字母中的一个，不区分大小写 | 

匹配ip地址
```shell
echo '127.255.255.254' | sed -n '/[0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+/p'
```




