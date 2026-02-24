#!/bin/sh

#export HOME_PATH=/data/overlay/alexa-release

export PATH=$PATH:${HOME_PATH}

cd ${HOME_PATH}
#ldd ${HOME_PATH}/avs-out/bin/SampleApp

#date -s 2017-1-1

#./avs-/bin/SampleApp AlexaClientSDKConfig.json  ${HOME_PATH}/avs-out/models/thfft_alexa_a_enus_v3_1mb.snsr DEBUG9
SampleApp AlexaClientSDKConfig.json  ${HOME_PATH}/models/f8/ DEBUG9
#./avs-out/bin/SampleApp AlexaClientSDKConfig.json  DEBUG0

