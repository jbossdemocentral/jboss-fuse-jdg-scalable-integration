#!/bin/bash
basedir=$(dirname $0)


DEMO="JBoss Fuse and Data Grid Demo"
AUTHORS="Thomas Qvarnstrom, Red Hat"
SRC_DIR=$basedir/installs

FUSE_INSTALL=jboss-fuse-full-6.1.1.redhat-412.zip
#JDG_INSTALL=jboss-datagrid-6.4.1-server.zip

SOFTWARE=($FUSE_INSTALL)


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
echo "Setting up the ${DEMO} environment..."
echo



# Check that maven is installed and on the path
mvn -v -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

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




# Unzip the maven repo files
echo "  - installing fuse"
echo
unzip -q -d target $SRC_DIR/$FUSE_INSTALL
if [ "$(uname)" =  "Linux" ]
then
	sed -i "s/#admin/admin/" target/jboss-fuse-6.*/etc/users.properties
else
	sed -i '' "s/#admin/admin/" target/jboss-fuse-6.*/etc/users.properties
fi

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

pushd target/jboss-fuse*/bin > /dev/null
./start
popd > /dev/null

#echo "  - starting datagrid"
#echo

#pushd target/jboss-datagrid*/bin > /dev/null
#./standalone.sh > /dev/null 2>&1 &
#popd > /dev/null

sleep 20

echo "  - starting client"
echo

mkdir -p logs

pushd $basedir/target/jboss-fuse*/bin > /dev/null

sh client -r 4 -d 10 "wait-for-service -t 300000 io.fabric8.api.BootstrapComplete"

echo "  - creating root container"
echo

#sh client -r 4 -d 10 "fabric:create --clean --wait-for-provisioning --profile fabric"

sh client -r 4 -d 10 "fabric:create --wait-for-provisioning"

#
# sh client -r 2 -d 10 "fabric:profile-edit --pid io.fabric8.agent/org.ops4j.pax.url.mvn.repositories='http://maven.repository.redhat.com/techpreview/all@id=techpreview-all-repository' default" > /dev/null 2>&1
#
# sh client -r 2 -d 10 "fabric:profile-edit --repositories mvn:org.apache.camel/camel-jbossdatagrid/6.4.1.Final-redhat-2/xml/features default" > /dev/null 2>&1
# #sh client -r 2 -d 10 "fabric:profile-edit --repositories mvn:org.infinispan/infinispan-remote/6.2.0.Final-redhat-4/xml/features default" > /dev/null 2>&1
#
# sh client -r 2 -d 10 "fabric:profile-edit --repositories mvn:org.jboss.demo.jdg/stock-ticker-features/1.0.0/xml/features default" > /dev/null 2>&1
#
# sh client -r 2 -d 10 "fabric:profile-create --parents feature-camel --version 1.0 demo-stock_ticker_integration" 2>&1
#
# sh client -r 2 -d 10 "fabric:version-create --parent 1.0 --default 1.1" > /dev/null 2>&1
#
# sh client -r 2 -d 10 "fabric:profile-edit --features stock-ticker-model demo-stock_ticker_integration 1.1" > /dev/null 2>&1
#
# sh client -r 2 -d 10 "fabric:profile-edit --features stock-ticker-integration demo-stock_ticker_integration 1.1" > /dev/null 2>&1
#
# sh client -r 2 -d 10 "container-upgrade --all 1.1" > /dev/null 2>&1
#
# sh client -r 2 -d 10 "container-create-child --profile demo-stock_ticker_integration root stock-ticker" > /dev/null 2>&1

popd > /dev/null

# echo "  - installing stock-ticker features"
# echo
# $basedir/support/install-features.sh
