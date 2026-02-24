#!/bin/sh


if [ -d $1 ]; then
	cd $1
else
	echo Packaging update.zip failed!
	exit 1
fi

rm -f update.zip
rm -f tmp_boot*
rm -f bootloader.img tpl.img system.img
rm -f bl2.bin tpl.bin
split -b 64k u-boot.bin tmp_boot
mv tmp_bootaa bl2.bin
cat tmp_boot* > tpl.bin
rm tmp_boot* -f

mv bl2.bin bootloader.img
mv tpl.bin tpl.img
cp rootfs.ubi system.img

#pack bootloader.img tpl.img boot.img system.img to update.zip
zip -q update.zip bootloader.img tpl.img boot.img system.img

if [ -e update.zip ]; then
	echo Packaged update.zip successfully!
else
	echo Packaging update.zip failed!
fi
