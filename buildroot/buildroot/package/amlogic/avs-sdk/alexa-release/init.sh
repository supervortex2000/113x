#!/bin/sh



screen_name1="avs"
screen -dmS $screen_name1
sleep 2
cmd1="sh ${HOME_PATH}/cron.sh";
screen -x -S $screen_name1 -p 0 -X stuff "$cmd1"
screen -x -S $screen_name1 -p 0 -X stuff $'\n'
sleep 2


screen_name2="update"
screen -dmS $screen_name2
sleep 2
cmd2="sh ${HOME_PATH}/update.sh";
screen -x -S $screen_name2 -p 0 -X stuff "$cmd2"
screen -x -S $screen_name2 -p 0 -X stuff $'\n'
sleep 2


exit 0
