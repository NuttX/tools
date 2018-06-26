#!/bin/bash
#set -x

WD=$PWD
TESTLIST=$1
HOSTOS=$(uname -o 2>/dev/null || echo "Other")

if [ -z "${PATH_ORIG}" ]; then
  export PATH_ORIG="${PATH}"
fi

rm -f armlist.dat
if [ "X${HOSTOS}" == "XCygwin" ]; then
  TOOLCHAIN_BIN="/cygdrive/c/Program Files (x86)/GNU Tools ARM Embedded/4.9 2015q2/bin"
  cat armlist.template | sed -e "s/_EABIx/_EABIW/g" >armlist.dat
  DEFLIST=armcygwin.dat
  OPTIONS="-w -c"
else
  TOOLCHAIN_BIN="/usr/bin/gcc-arm-none-eabi-6-2017-q2-update/bin"
  cat armlist.template | sed -e "s/_EABIx/_EABIL/g" >armlist.dat
  OPTIONS=-l
fi
export PATH="${TOOLCHAIN_BIN}:/sbin:/usr/sbin:${PATH_ORIG}"

if [ -z "$TESTLIST" ]; then
  TESTLIST=armlist.dat
fi

NUTTX=$PWD/../nuttx
if [ ! -d "$NUTTX" ]; then
  echo "Where are you?"
  exit 1
fi

TESTBUILD=$NUTTX/tools/testbuild.sh
if [ ! -x "$TESTBUILD" ]; then
  echo "Help!!! I can't find testbuild.sh"
  exit 1
fi

$TESTBUILD $OPTIONS $TESTLIST 1>armtest.log 2>&1
rm -f armlist.dat
