#!/usr/bin/env bash
PICORE_ZIP_URL=http://tinycorelinux.net/8.x/armv6/releases/RPi/piCore-8.0.zip
PICORE_IMG_FILE=piCore-8.0.img
PICORE_ZIP_FILE=tmp/piCore.zip

if [ ! -d tmp ]; then
	mkdir tmp
fi

if [ ! -d piCore-root ]; then
	mkdir piCore-root
fi

if [ ! -f $PICORE_ZIP_FILE ]; then
	wget $PICORE_ZIP_URL -O $PICORE_ZIP_FILE
fi

if [ ! -f "tmp/$PICORE_IMG_FILE" ]; then
	unzip -o $PICORE_ZIP_FILE $PICORE_IMG_FILE -d tmp
fi

IMG_REAL_SIZE=$(wc -c "tmp/$PICORE_IMG_FILE" | cut -d' ' -f1)
IMG_FDISK_SIZE=$(fdisk -l "tmp/$PICORE_IMG_FILE" \
	| tail -2 | sed -r 's/ +/ /g' | cut -d' ' -f2-4 \
	| sed -e :a -e N -e 's/\n/ /' -e ta \
	| sed -r 's/^/a1=/;s/ /\nb1=/;s/ /\nc1=/;s/ /\na2=/;s/ /\nb2=/;s/ /\nc2=/;s/$/\n(a1+c1+(a2-b1)+c2)*512/' \
	| bc \
)
SIZE_DIFF=$((IMG_REAL_SIZE-IMG_FDISK_SIZE))

if [ $SIZE_DIFF -lt 0 ]; then
	dd if=/dev/zero of=tmp/zero bs=512 count=$(((SIZE_DIFF*-1)/512))
	cat tmp/zero >> "tmp/$PICORE_IMG_FILE"
fi
