1. exit alexa program : run '/usr/share/alexa-release/screen -r avs' to enter console of running program ,press "q" first ,then ctrl+c to exit!!!
2. remove old version : rm -rf /usr/share/alexa-release
3. install to device: move to the folder contain alexa-release folder',run 'adb push alexa-release /mnt/UDISK/alexa-release/'
4. setup enviroment: run '/mnt/UDISK/alexa-release/setup.sh' and  '/mnt/UDISK/alexa-release/install.sh'
5. mkdir /usr/share/alexa-release
6. copy cert file: 'cp /mnt/UDISK/alexa-release/curl-ca-bundle.crt /usr/share/alexa-release/'
7. run 'reboot' to restart
