#! /bin/bash
echo "Disabling I2C and SPI"
sudo raspi-config nonint get_i2c >> /dev/null 2>&1
if [ $? -eq 0 ]; then
  sudo raspi-config nonint do_i2c 1
fi

sudo raspi-config nonint get_spi >> /dev/null 2>&1
if [ $? -eq 0 ]; then
  sudo raspi-config nonint do_spi 1
fi

echo "Fixing dependency."
sudo pip install pycparser==2.21
sudo pip install setuptools==44.1.1
echo "dependency fix done."

echo "Running update_grovepi"
sudo -u pi curl -L dexterindustries.com/update_grovepi >> .tmp_updategrovepi
sudo -u pi bash .tmp_updategrovepi
sudo rm .tmp_updategrovepi
echo "Grove Lib update complete."

echo "Pulling new firmware" 
cd /home/pi/Desktop/GrovePi && sudo git fetch origin && sudo git reset --hard && sudo git merge origin/master

echo "reflashing firmware, when prompted, type y and enter to start flashing."
sudo bash /home/pi/Dexter/GrovePi/Firmware/firmware_update.sh 
y
echo "Flashing Complete"

echo "Reenabling I2C and SPI"
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_spi 0
echo "done."

exit 0
