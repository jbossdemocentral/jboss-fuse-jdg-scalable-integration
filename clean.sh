#!/bin/bash
basedir=`dirname $0`


DEMO="JBoss Fuse and Data Grid Stock Ticker Demo"
AUTHORS="Thomas Qvarnstrom, Red Hat & Christina Lin, Red Hat"
SRC_DIR=$basedir/installs

FUSE_INSTALL=jboss-fuse-full-6.2.0.redhat-133.zip
JDG_INSTALL=jboss-datagrid-6.5.0-server.zip

SOFTWARE=($FUSE_INSTALL $JDG_INSTALL)


# wipe screen.
clear 

echo

ASCII_WIDTH=57
printf "##  %-${ASCII_WIDTH}s  ##\n" | sed -e 's/ /#/g'
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" "Setting up the ${DEMO}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # ###   ###        #### #  #  ### ####"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # #  # #       #   #    #  # #    #"
printf "##  %-${ASCII_WIDTH}s  ##\n" "    # #  # #  ##  ###  ###  #  # #### ####"
printf "##  %-${ASCII_WIDTH}s  ##\n" "#   # #  # #   #   #   #    #  #    # #"
printf "##  %-${ASCII_WIDTH}s  ##\n" " ###  ###   ###        #    #### ###  ####"  
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
if [ -x projects/stock-ticker/stock-ticker-historicalquote/target ]; then
		echo "  - deleting existing historicalquote project target directory..."
		echo
		rm -rf projects/stock-ticker/stock-ticker-historicalquote/target
fi

# If target directory exists remove it
if [ -x projects/stock-ticker/stock-ticker-model/target ]; then
		echo "  - deleting existing historicalquote project target directory..."
		echo
		rm -rf projects/stock-ticker/stock-ticker-model/target
fi

# If target directory exists remove it
if [ -x projects/stock-ticker/stock-ticker-ploter/target ]; then
		echo "  - deleting existing ploter project target directory..."
		echo
		rm -rf projects/stock-ticker/stock-ticker-ploter/target
fi

# If target directory exists remove it
if [ -x target ]; then
		echo "  - deleting existing target directory..."
		echo
		rm -rf target
fi
