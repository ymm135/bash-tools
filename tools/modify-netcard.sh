#!/usr/bin/env bash

echo -e "modify netcard name to eth"
ls -l /etc/sysconfig/network-scripts/ifcfg-eth*

# 需要先修改network-scripts的名称为eth开头
if (($? != 0)); then
    echo "Please modify /etc/sysconfig/network-scripts/ifcfg-eth* first!! Error"
    exit
fi

pcis=$(ls -l /sys/class/net/ | grep -Eo '/devices/pci.+net')

echo -e "modify netcard pcis=$pcis"

# 遍历结果
netRuleFile="/etc/udev/rules.d/99-persistent-net.rules"

if [ -f "$netRuleFile" ]; then
    echo -e "modify netcard remove old file $netRuleFile"
    rm -fr $netRuleFile
fi

netcardIndex=0
for pci in ${pcis[@]}; do
    echo -e "SUBSYSTEM==\"net\",ACTION==\"add\",DRIVERS==\"?*\", DEVPATH==\"${pci}*\", NAME=\"eth$netcardIndex\"" >>$netRuleFile
    netcardIndex=$((netcardIndex + 1))
done
