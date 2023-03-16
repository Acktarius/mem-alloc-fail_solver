#!/bin/bash
#check hugepage and change as needed
hp=$(/sbin/sysctl vm.nr_hugepages | cut -d " " -f 3)
if [ $hp = "0" ]; then
echo "vm.nr_hugepages=128" >> /etc/sysctl.d/60-hugepages.conf
echo "/etc/sysctl.d/60-hugepages.conf modified" 
else
echo "no change needed for hugepages"
fi
#check memory alloc and change as needed
ml=$(ulimit -l)
if (( $ml < 262144 )); then
echo "*    - memlock 262144 root - memlock 262144" >> /etc/security/limits.d/60-memlock.conf
else
echo "no change needed for memlock"
fi
#apply those settings if they have been changed
if [ $hp = "0" ]; then
sudo sysctl --system
fi
echo -e "\n------ results : ------\n"
/sbin/sysctl vm.nr_hugepages 
echo -e "memlock: $(ulimit -l)\n"
exit