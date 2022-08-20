# DevOps
## web-server-bin  
目录结构
```shell
web-server-bin
        ├── README.md
        ├── build
        │   └── build_soft.sh
        ├── build.sh
        ├── build_update_pack.sh
        ├── config
        │   └── config.sh
        ├── git
        │   └── git_utils.sh
        ├── test
        │   ├── a.sh
        │   └── test.sh
        ├── update
        │   └── manualUpdateSoft.sh
        └── update_script.sh
```

### 


## Linux系统还原及备份
[详细说明](https://github.com/ymm135/docs/blob/master/DevOps/linux-backup-restore.md)  

> 网卡的还原, 需要写入硬件信息    
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

