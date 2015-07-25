#!/bin/bash
basedir=$(dirname $0)


DEMO="JBoss Fuse and Data Grid Stock Ticker Demo"
AUTHORS="Thomas Qvarnstrom, Christina Lin, Red Hat"
SRC_DIR=$basedir/installs

#JDG_INSTALL=jboss-datagrid-6.4.1-server.zip

#Fuse env 
DEMO_HOME=./target
SUPPORT_DIR=./support
FUSE_ZIP=jboss-fuse-full-6.2.0.redhat-133.zip
FUSE_HOME=$DEMO_HOME/jboss-fuse-6.2.0.redhat-133
FUSE_PROJECT=projects/stock-ticker
FUSE_SERVER_CONF=$FUSE_HOME/etc
FUSE_SERVER_BIN=$FUSE_HOME/bin

SOFTWARE=($FUSE_ZIP)


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
echo "Setting up the ${DEMO} environment..."
echo



# Check that maven is installed and on the path
mvn -v -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }


# Check mvn version must be in 3.1.1 to 3.2.4	
verone=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $1}')
vertwo=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $2}')
verthree=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $3}')     
     
if [[ $verone -eq 3 ]] && [[ $vertwo -eq 1 ]] && [[ $verthree -ge 1 ]]; then
		echo  Correct Maven version $verone.$vertwo.$verthree
		echo
elif [[ $verone -eq 3 ]] && [[ $vertwo -eq 2 ]] && [[ $verthree -le 4 ]]; then
		echo  Correct Maven version $verone.$vertwo.$verthree
		echo
else
		echo Please make sure you have Maven 3.1.1 - 3.2.4 installed in order to use fabric maven plugin.
		echo
		echo We are unable to run with current installed maven version: $verone.$vertwo.$verthree
		echo	
		exit
fi


# Verify that necesary files are downloaded
for DONWLOAD in ${SOFTWARE[@]}
do
	if [[ -r $SRC_DIR/$DONWLOAD || -L $SRC_DIR/$DONWLOAD ]]; then
			echo $DONWLOAD are present...
			echo
	else
			echo You need to download $DONWLOAD from the Customer Support Portal
			echo and place it in the $SRC_DIR directory to proceed...
			echo
			exit
	fi
done

#If fuse is running stop it
echo "  - stopping any running fuse instances"
echo
jps -lm | grep karaf | grep -v grep | awk '{print $1}' | xargs kill -KILL

#If JDG is running stop it
echo "  - stopping any running datagrid instances"
jps -lm | grep jboss-datagrid | grep -v grep | awk '{print $1}' | xargs kill -KILL

sleep 2

echo


# Create the target directory if it does not already exist.
if [ -x target ]; then
		echo "  - deleting existing target directory..."
		echo
		rm -rf target
fi
echo "  - creating the target directory..."
echo
mkdir target

echo "  - unzip FUSE..."
echo
#Start Fuse installation
if [ -x target ]; then
  # Unzip the JBoss FUSE instance.
	echo
  echo Installing JBoss FUSE 
  echo
  unzip -q -d target $SRC_DIR/$FUSE_ZIP
else
	echo
	echo Missing target directory, stopping installation.
	echo 
	exit
fi



#SETUP and INSTALL FUSE services
echo "  - enabling demo accounts logins in users.properties file..."
echo
cp $SUPPORT_DIR/fuse/users.properties $FUSE_SERVER_CONF

echo "  - enable camel counter in console in jmx.acl.whitelist.cfg  ..."
echo
cp $SUPPORT_DIR/fuse/jmx.acl.whitelist.cfg $FUSE_SERVER_CONF/auth/

echo "  - enable camel counter in console in jmx.acl.whitelist.properties  ..."
echo
cp $SUPPORT_DIR/fuse/jmx.acl.whitelist.properties $FUSE_HOME/fabric/import/fabric/profiles/default.profile/

echo "  - adding DataGrid repo to org.ops4j.pax.url.mvn.cfg file..."
echo
cp $SUPPORT_DIR/fuse/org.ops4j.pax.url.mvn.cfg $FUSE_SERVER_CONF

echo "  - adding DataGrid repo to io.fabric8.agent.properties file..."
echo
cp $SUPPORT_DIR/fuse/io.fabric8.agent.properties $FUSE_HOME/fabric/import/fabric/profiles/default.profile/

 


#echo "  - installing datagrid"
#echo
#unzip -q -d target $SRC_DIR/$JDG_INSTALL


# Build the projects
# echo "  - building the stock-ticker project"
# echo
# pushd projects/stock-ticker > /dev/null
# mvn -q clean install
# popd > /dev/null

echo "  - starting fuse"
echo


echo "  - Start up Fuse in the background"
echo
sh $FUSE_SERVER_BIN/start

echo "  - Create Fabric in Fuse"
echo
sh $FUSE_SERVER_BIN/client -r 3 -d 10 -u admin -p admin 'fabric:create' > /dev/null


COUNTER=10
#===Test if the fabric is ready=====================================
echo "  - Testing fabric,retry when not ready"
while true; do
    if [ $(sh $FUSE_SERVER_BIN/client 'fabric:status'| grep "100%" | wc -l ) -ge 3 ]; then
        break
    fi
    
    if [  $COUNTER -le 0 ]; then
    	echo ERROR, while creating Fabric, please check your Network settings.
    	break
    fi
    let COUNTER=COUNTER-1
    sleep 2
done
#===================================================================


cd $FUSE_PROJECT/stock-ticker-historicalquote


echo "  - deploy stock ticker historical order integration to fabric"
echo
mvn fabric8:deploy


cd ../stock-ticker-ploter

echo "  - package stock ticker ploter"
echo
mvn clean install
mvn assembly:single

#Back to project dir
cd ../../..

echo "  - Create containers "
echo         
sh $FUSE_SERVER_BIN/client -r 2 -d 5 'container-create-child root tickercon'


# echo "  - installing stock-ticker features"
# echo
# $basedir/support/install-features.sh


ASCII_WIDTH=105

printf "=  %-${ASCII_WIDTH}s  =\n" | sed -e 's/ /#/g'
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" " Starting the camel route in JBoss Fuse as follows:"
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" "    - login to Fuse management console at:"
printf "=  %-${ASCII_WIDTH}s  =\n" 
printf "=  %-${ASCII_WIDTH}s  =\n" "        http://localhost:8181    (u:admin/p:admin)"
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" "    - go to Services Tab, under container, find containt tickercon"  
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" "        add profile demo-jdg-stockticker to tickercon container"
printf "=  %-${ASCII_WIDTH}s  =\n" 
printf "=  %-${ASCII_WIDTH}s  =\n" "    - start up ploter, go to /support folder "
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" "        run ./start-client.sh"
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" "    - start stock quote and order, place the /support/stockorderRHT1001.xml file to "
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" "        target/jboss-fuse-6.2.0.redhat-133/instances/tickercon/stockfolder"
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" "    - once you are done, to stop and clean everything run"
printf "=  %-${ASCII_WIDTH}s  =\n" "        ./clean.sh"
printf "=  %-${ASCII_WIDTH}s  =\n"
printf "=  %-${ASCII_WIDTH}s  =\n" | sed -e 's/ /#/g'

