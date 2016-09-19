#! /bin/bash
# After WittyPi2 install: http://www.uugear.com/product/wittypi2
# cd; wget http://www.uugear.com/repo/WittyPi2/installWittyPi.sh
# sudo sh installWittyPi.sh
# cd; wget http://pierriko.com/wiibee/install.sh
# sudo sh install.sh
USB_DEV=/dev/sda1
USB_MNT=/mnt/bee1
logger "Check if USB disk is plugged in"
[ -e $USB_DEV ] && logger "mount $USB_DEV" || logger "missing $USB_DEV"
[ -d $USB_MNT ] || mkdir -p $USB_MNT
mount $USB_DEV $USB_MNT
cd $USB_MNT
git clone https://github.com/pierriko/wiibee.git; cd wiibee
wget https://raw.githubusercontent.com/pierriko/wiiboard/master/wiiboard.py
touch wiibee.js; git add wiibee.js
git commit wiibee.js -m"[data] first commit $(date -Is)"
# TODO https://help.github.com/articles/generating-an-ssh-key/
git remote add ssh git@github.com:pierriko/wiibee.git
cp wittyPi/schedule.wpi ~/wittyPi/
cp wittyPi/extraTasks.sh ~/wittyPi/
chmod +x ~/wittyPi/extraTasks.sh
chown -R pi:pi ~/wittyPi
cd ~/wittyPi; . runScript.sh
