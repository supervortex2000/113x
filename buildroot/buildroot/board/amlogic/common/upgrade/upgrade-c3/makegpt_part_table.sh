#! /bin/sh
#-o:out put gpt.bin path
#-s: mmc size
#-v:2
#--partitions:part table,same as dts

BIN_PATH=$1
OUTPUT_PATH=$2
${BIN_PATH}/makegpt -o ${OUTPUT_PATH}/gpt.bin -s 8G -v 2 --partitions ${OUTPUT_PATH}/gpt_part_table.txt
