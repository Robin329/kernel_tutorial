#!/bin/bash
#
# dis_test.sh -- DISPLAY test scripts.
#
# Copyright (C) 2020 Robin Jiang <robin.jiang@xgimi.com>.
#
# This script mainly tests the case related to the display module, 
# replacing the remote control and manual operation, and is designed 
# to quickly reproduce some bugs.
#
# To run this script, do the following:
# 
#	- 1. Unplug the power and power on to restart the machine.
#	- 2. Keep the machine on.
#
# Note: This script is only suitable for the new GMUI interface, if it
#       is the old GMUI, you need to modify this script and adapt it.
#
#
###########################
# Dis_test.sh versioning:
###########################
# dis_test.sh supports '--version' option, returns the version number.
# Version number is based on the features/commands supported by it.
#
# Version 0:
#		Supports just the basic mode. As follows:
#			- 1. 
#			- 2.
#			- 3. 
#			- 4.
#			- 5. 
#
#
# Version 1:
#
#
# Version 2:
#

# Version Number
BUILD_SH_VERSION=0


# variable value
TEST_MODES=None
mode=0
times=0
SAVE_LOG=0

# Input keyevent



if [ "$1" == "--version" ]; then
	return $BUILD_SH_VERSION
	exit 0
fi

function usage() {
	echo
	echo "************************************************************"
	echo "Usage:"
	echo "	1 =>	"
	echo "	2 =>	"
	echo "	3 =>	"
	echo "	4 =>	"
	echo "	5 =>	"
	echo "	6 =>	"
	echo
	echo "You can also use the following methods:"
	echo
	echo "./dis_test.sh [mode] [times] [log]"
	echo
	echo "	[mode]:  As Usage info."
	echo "	[times]: Test times."
	echo "	[log]:   Wether need save log(0/1)?"
	echo
	echo "Example:"
	echo "	./dis_test.sh 1 10000 1 "
	echo "	=> Test [3D] mode [10000] times and save log."
	echo "************************************************************"
}
function backlanucher() {
     echo
     echo "--------------Back To Launcher--------------"
     echo
}

# Save log to /data/dis_test.log
function savelog() {
	echo
	echo "Start Save GM_DISP log in path:/data/dis_test.log"
	echo
	nohup logcat | grep -e GM_DISP | tee /data/dis_test.log &
}
# Test times
function testtimes() {
	if [ "$times" != "0" ];then
		return $times
	else
		read -p "How many times do you want to test [$TEST_MODES] ? " times
		echo "$times times"
	fi
}

# You need to start this function in the main menu interface.
function play4Kvideo() {
	backlanucher
	echo
	echo "--------------Play 4k Video--------------"

}

# You need to start this function in the main menu interface.
function play3Dvideo() {
	backlanucher
	echo
	echo "--------------Play 3D Video--------------"
	echo

}

function 3D() {
	echo 
	read -p "You want test 3D under (1:3Dvideo/2:4Kvideo)? " num
	case "$num" in
		1*)
			play3Dvideo
			;;
		2*)
			play4Kvideo
			;;
		*)
			echo "Please input (1/2)!!"
			3D
			;;
		esac
	echo
	echo "--------------3D test-------------------"
	echo 
	i=1
	while (($i < $times));do
		echo "==> 3D test [$i] times <=="
		sleep 1
		i=`expr $i + 1`
	done
}

function projectormode() {
	echo 
	echo "--------------Projector mode test-------"
	echo
}

function lumensmode() {
	echo
	echo "--------------Lumensmode test--------------"
	echo
}

function testmodes() {
	if [ "$1" != "0" ];then
		mode=$1
	else
		echo
		read -p "Which one do you want to test? " mode
		echo
	fi
	case $mode in
		1*)
			echo " 1 => "
			TEST_MODES=3D
			;;
		2*)
			echo " 2 => "
			TEST_MODES=LumensMode
			;;
		3*)
			echo " 3 => "
			TEST_MODES=ProjectorMode
			;;
		4*)
			echo " 4 => "
			TEST_MODES=
			;;
		5*)
			echo " 5 => "
			TEST_MODES=
			;;
		6*)
			echo " 6 => "
			TEST_MODES=$mode
			;;
		None|*)
			echo "mode $mode"
			usage
			;;
	esac
	testtimes $1 $2 $3
}

function dis_test() {
	
	if [ $# == "0" ]; then
	    usage
	else
		while (( $# )); do
			case $1 in
				--help|-h)
					usage
					echo "hello1"
					shift
					exit 1
					;;
				1|2|3|4|5|6)
					mode=$1
					shift
					if [ ! $1 ];then
						echo "Please input test times!!"
						exit 1
					else
						times=$1
						echo "==> test [$times] times"
					fi
					shift
					if [ "$1" == "" ] || [ "$1" == "0" ];then
						echo
						echo "==> Won't Save Test log!!"
					else
						SAVE_LOG=$1
					fi
					shift
					;;
				*)
					usage
					;;
			esac
		done
	fi
	testmodes $mode $2 $3
	echo "TEST_MODES is $TEST_MODES"
	case $TEST_MODES in
		3D*)
			3D
			;;
		ProjectorMode*)
			projectormode
			;;
		LumensMode*)
			lumensmode
			;;
		4*)

			;;
		5*)

			;;
		6*)

			;;
		*)
			usage
			;;
		esac
	if [ "$SAVE_LOG" == "1" ];then
		echo
		echo "==> Start save log to /data/dis_test.log!"
		savelog
	fi
}

echo
echo -e "\033[31m === Please Check Under Main Launcher Test!! ===\033[0m"
echo "param $# $1 $2 $3"
dis_test $1 $2 $3
exit 1
