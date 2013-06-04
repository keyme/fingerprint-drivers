#!/bin/sh

# Copyright (c) 2011 DigitalPersona, Inc.
#
# http://www.digitalpersona.com
#
umask 022

RELPATH=`dirname $0`
RELPATH=`cd $RELPATH;pwd`
echo "RELPATH: $RELPATH"

SDK_VERSION=2.0.0
TOOLKIT_VERSION=5.3.0
DRIVER_VERSION=2.0.0.7

FNAME=DigitalPersona-UareU-SDK-2.0.0-1.noarch.tar.gz
MD5SUM=2364c125e5fcea9b7cdb3981614334d6
FSIZE=3476186
FTYPE=gz
PVER=

# Ask user to install tar packages if no RPM
#
KVER=`uname -r`
PLAT=`uname -i`

# Use /tmp to store the package, as the current directory
# may not be writable, ie. on a CD-ROM.
#
SDKPKG=$RELPATH/drivers.tar.gz
INIT_DIR=`pwd`

echo "Installing the TAR packages..."

cd /opt
echo "The files will be extracted into /opt/DigitalPersona."
CONTENTFILE="DigitalPersona/.filelist-uareu"
mkdir -p `dirname $CONTENTFILE`
if [ -f $CONTENTFILE ]; then
  rm $CONTENTFILE
fi

# install RTE package
cd /opt
tar -zxvf $SDKPKG --no-same-owner
tar -ztf $SDKPKG >>$CONTENTFILE

echo ""

cd $INIT_DIR

if [ -d /opt/DigitalPersona/lib64 ]; then

  # Target machine is running 32bit OS
  #
  if [ "`uname -m`" = "i686" ]; then
    # Redhat based multilib: /usr/lib (32bit) and /usr/lib64 (64bit)
    if ([ -d /usr/lib ] && [ -d /usr/lib64 ]); then
      for LIB in /opt/DigitalPersona/lib64/*
      do
        if [ ! -L /usr/lib64/`basename $LIB` ]; then
          ln -s $LIB /usr/lib64/`basename $LIB`
        fi
      done
    fi
    # Debian based multilib: /usr/lib32 (32bit) and /usr/lib (64bit)
    if ([ -d /usr/lib ] && [ -d /usr/lib32 ]); then
      for LIB in /opt/DigitalPersona/lib64/*
      do
        if [ ! -L /usr/lib/`basename $LIB` ]; then
          ln -s $LIB /usr/lib/`basename $LIB`
        fi
      done
    fi
  fi

  # Target machine is running 64bit OS
  #
  if [ "`uname -m`" = "x86_64" ]; then
    if [ ! -L /opt/DigitalPersona/lib ]; then
      ln -s /opt/DigitalPersona/lib64 /opt/DigitalPersona/lib
    fi

    # Redhat based multilib: /usr/lib (32bit) and /usr/lib64 (64bit)
    if ([ -d /usr/lib ] && [ -d /usr/lib64 ]); then
      for LIB in /opt/DigitalPersona/lib64/*
      do
        if [ ! -L /usr/lib64/`basename $LIB` ]; then
          ln -s $LIB /usr/lib64/`basename $LIB`
        fi
      done
    fi
    # Debian based multilib: /usr/lib32 (32bit) and /usr/lib (64bit)
    if ([ -d /usr/lib ] && [ -d /usr/lib32 ]); then
      for LIB in /opt/DigitalPersona/lib64/*
      do
        if [ ! -L /usr/lib/`basename $LIB` ]; then
          ln -s $LIB /usr/lib/`basename $LIB`
        fi
      done
    fi
  fi
fi

if ([ -d /opt/DigitalPersona/UareUSDK/include ] && [ ! -L /usr/include/DigitalPersona ]); then
  ln -s /opt/DigitalPersona/UareUSDK/include /usr/include/DigitalPersona
fi

cd $INIT_DIR

if [ -s uninstall ]; then
	cp uninstall /opt/DigitalPersona/.
fi

echo " "
echo "Done."
exit 0
