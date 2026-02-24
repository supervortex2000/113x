#/bin/bash

#The number of channels supported is 2 4 6 8
# TEST_MODE 1 pseudo soldering: filter mode set 1, test TEST_MODE 2 block : filter mode set 0

echo "Usage : ./pdm_mic_test.sh  CHANNEL TEST_MODE FILTER_MODE SPK_DEVICE MIC_DEVICE "

CHANNEL=$1
TEST_MODE=$2
FILTER_MODE=$3
SPK_DEVICE=$4
MIC_DEVICE=$5

echo $SPK_DEVICE  $MIC_DEVICE

if [ $# -ne 5 ]; then
	echo "Missing parameters, please check the input parameters are correct"
	exit 0;
else
	if [ $CHANNEL -lt 1 -o $CHANNEL -gt 8 ]; then
		echo "Please input the correct number of channels:1-8channel"
		exit 0;
	fi

	if [ $TEST_MODE -ne 1 -a $TEST_MODE -ne 2 ]; then
		echo "test mode error,test mode :(1: Pseudo Soldering, 2:block)"
		exit 0;
	fi
fi

# rm /data/pdm_test.wav
rm /data/pdm_test.wav

# set volume for aplay mic test audio file
echo "please adjust the amixer volume and calibrate to 94db"

# normal mode:0  Bypass mode :1
amixer cset numid=38,iface=MIXER,name='PDM Bypass' $FILTER_MODE
sync
sleep 1

echo "MIC test begin >>>>>>>>>"

aplay -D $SPK_DEVICE /usr/share/sounds/2ch_1khz-16b-10s.wav &
sleep 1
arecord -D $MIC_DEVICE -c $CHANNEL -r 48000 -f S32_LE  -t raw -d 5 /data/pdm_test.wav

sleep 2
sync
killall aplay

/usr/bin/Aml_Mic_Test -f /data/pdm_test.wav -c $CHANNEL -j $TEST_MODE
Aml_Mic_Test_Ret=$?
sleep 1

echo PDM MIC test result:

if [ $Aml_Mic_Test_Ret -eq 0 ]; then
	if [ $TEST_MODE -eq 1 ]; then
		echo no channel is Pseudo Soldering
	else
		echo no channel is blocked
	fi
	exit 1;
else
	j=`expr $CHANNEL - 1`

	for i in `seq 0 $j`
	do
		if [ $(($Aml_Mic_Test_Ret & 2**$i)) -ne 0 ]; then
		echo -n $(($i+1)) "channel " ;
		fi
	done
	if [ $TEST_MODE -eq 1 ]; then
		echo Pseudo Soldering
	else
		echo block
	fi
fi

echo "MIC test end >>>>>>>>>>"
