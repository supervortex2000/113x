#!/bin/sh
temp=$(echo `pidof ./avs-out/bin/SampleApp`)
kill -9 $temp
