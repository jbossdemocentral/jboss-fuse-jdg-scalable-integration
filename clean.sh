#!/bin/bash
basedir=`dirname $0`


DEMO="JBoss Fuse and Data Grid Demo"
AUTHORS="Thomas Qvarnstrom, Red Hat & Christina Lin, Red Hat"
SRC_DIR=$basedir/installs

FUSE_INSTALL=jboss-fuse-full-6.1.1.redhat-412.zip
JDG_INSTALL=jboss-datagrid-6.4.0-server.zip

SOFTWARE=($FUSE_INSTALL $JDG_INSTALL)


# wipe screen.
clear 

echo

ASCII_WIDTH=52

printf "##  %-${ASCII_WIDTH}s  ##\n" | sed -e 's/ /#/g'
printf "##  %-${ASCII_WIDTH}s  ##\n"   
printf "##  %-${ASCII_WIDTH}s  ##\n" "Setting up the ${DEMO}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # ####   ###   ###  ###   ###   ###"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # #   # #   # #    #      #  # #"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # ####  #   #  ##   ##    #  # #  ##"
printf "##  %-${ASCII_WIDTH}s  ##\n" "#   # #   # #   #    #    #   #  # #   #"
printf "##  %-${ASCII_WIDTH}s  ##\n" " ###  ####   ###  ###  ###    ###   ###"  
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"   
printf "##  %-${ASCII_WIDTH}s  ##\n" "brought to you by,"
printf "##  %-${ASCII_WIDTH}s  ##\n" "${AUTHORS}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" | sed -e 's/ /#/g'

echo
echo "Cleaning up the ${DEMO} environment..."
echo

#If fuse is running stop it
echo "  - stopping any running fuse instances"
echo
jps -lm | grep karaf | grep -v grep | awk '{print $1}' | xargs kill -KILL

#If JDG is running stop it
echo "  - stopping any running datagrid instances"
jps -lm | grep jboss-datagrid | grep -v grep | awk '{print $1}' | xargs kill -KILL

sleep 2 

echo


# If target directory exists remove it
if [ -x target ]; then
		echo "  - deleting existing target directory..."
		echo
		rm -rf target
fi
