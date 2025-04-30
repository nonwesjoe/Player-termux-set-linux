#!/bin/bash
cat<<EOL>resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOL

cat<<EOL>hosts
127.0.0.1 localhost
EOL

cat<<EOL>locale.conf
LANG=en_US.UTF-8
EOL

cat<<EOL>.bashrc
#!/bin/bash
clear
neofetch
EOL

chmod +x /.bashrc

mv -vf resolv.conf /etc/resolv.conf
mv -vf hosts /etc/hosts
mv -vf locale.conf /etc/locale.conf

groupadd -g 3003 aid_inet
groupadd -g 3004 aid_net_raw
groupadd -g 1003 aid_graphics
usermod -g 3003 -G 3003,3004 -a _apt
usermod -G 3003 -a root

sed -i '$ a\max ALL=(ALL:ALL) ALL' /etc/sudoers
sed -i '$ a\deb http://ftp.de.debian.org/debian sid main' /etc/apt/sources.list
sed -i '$ a\deb http://ftp.us.debian.org/debian sid main' /etc/apt/sources. list

apt update
apt upgrade
apt install -y wget nano neofetch sudo git net-tools
echo "next"

groupadd storage
groupadd wheel
useradd -m -g users -G wheel,audio,video,storage,aid_inet -s /bin/bash max
echo "SET YOUR PASSWORD"
passwd max

apt update
apt install neofetch

echo done
