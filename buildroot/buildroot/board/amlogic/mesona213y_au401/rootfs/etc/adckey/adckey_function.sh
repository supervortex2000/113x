# cat adckey_function.sh 
#!/bin/sh

powerStateFile="/sys/power/state"
wake_lockFile="/sys/power/wake_lock"

wait_wake_lock()
{
    #check wake_lock begin
    local cnt=10
    while [ $cnt -gt 0 ]; do
        lock=`cat $wake_lockFile`
        if [ ! $lock ];then
            break
        fi
        sleep 1;
        cnt=$((cnt - 1))
        echo "suspend waiting wake_lock to be released..."
    done
    if [ $cnt -eq 0 ];then
        echo "wait suspend timeout, abort suspend"
        echo "unreleased wake_lock: $lock"
        exit 0
    fi
}

powerStateChange()
{
    #######suspend#######
    echo "suspend start..."
    wait_wake_lock
    echo "mem" > $powerStateFile
}

Screen()
{
    if [ `grep  -c "OFF" /sys/class/lcd/enable` -eq '0' ] ;then
        echo 0 > /sys/class/lcd/enable
        echo "Lcd status: off"
    else
        echo 1 > /sys/class/lcd/enable
        echo "Lcd status: on"
    fi
}

case $1 in
    "power") Screen ;;
    "longpresspower") powerStateChange;;
    *) echo "no function to add this case: $1" ;;
esac

exit
#
