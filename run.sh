#!/bin/bash

pkg update -y  
pkg install wget root-repo tar expect -y  
pkg update && pkg install tsu -y   
echo done with the first step  

# second strp
echo second step to get debian
cd /data/local/tmp  
sudo wget wget https://github.com/LinuxDroidMaster/Termux-Desktops/releases/download/Debian/debian12-arm64.tar.gz
sudo mkdir debian
cd debian
sudo tar xvf /data/local/tmp/debian12-arm64.tar.gz --numeric-owner 
sudo mkdir media
sudo mkdir media/sdcard
sudo mkdir dev/shm
sudo mkdir dev/pts
echo files ready
# 
cd $HOME
mkdir .shortcuts
mkdir sh
cd sh
cat<<EOL>startdebian.sh
#!/bin/sh
mnt="/data/local/tmp/debian"
busybox mount -o remount,dev,suid /data
mount -o bind /dev \mnt/dev/
busybox mount -t proc proc \$mnt/proc/
busybox mount -t sysfs sysfs \$mnt/sys/
busybox mount -t devpts devpts \$mnt/dev/pts/
busybox mount -o bind /sdcard \$mnt/media/sdcard
busybox mount -t tmpfs /cache \$mnt/var/cache
busybox mount -t tmpfs -o size=256M tmpfs \$mnt/dev/shm
busybox chroot \$mnt /bin/su - root -c "bash"
EOL

sudo chmod +x startdebian.sh  
cd ~/.shortcuts  
cat<<EOL>debian
#!/bin/bash
su -c "sh $HOME/sh/startdebian.sh"
EOL

chmod +x debian
echo 'export PATH=$PATH:$HOME/.shortcuts' >> /data/data/com.termux/files/usr/etc/termux-login.sh

pkg install neofetch
neofetch
echo "====================================================================================="
echo run "debian" to login

sudo cp /data/data/com.termux/files/home/termux-set-debian/init.sh /data/local/tmp/debian/
echo "run exit to restart termux and run debian to login"
