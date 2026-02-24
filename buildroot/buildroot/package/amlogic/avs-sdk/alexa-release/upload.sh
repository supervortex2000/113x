#!/bin/sh
export LD_LIBRARY_PATH=${HOME_PATH}/avs-out/lib
${HOME_PATH}/avs-out/bin/curl  $1/api/upload -F "file=@$2"

