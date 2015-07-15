#!/bin/bash
basedir=`dirname $0`

FAB_PROFILE=demo-stock_ticker_integration
CONTAINER=stock-ticker

pushd $basedir/../target/jboss-fuse*/bin > /dev/null

#Check if fuse is running stop it
echo "  - Checking that fuse is running..."
test $(jps -lm | grep karaf | grep -v grep | wc -l) -gt 0 && echo "Fuse is running " || { echo >&2 "Fuse is not started... aborting."; exit 1; }
echo

echo " - Check that container exists"
test $(./client "fabric:container-list" 2>/dev/null | grep $CONTAINER | wc -l ) -gt 0 &&  { echo "container $CONTAINER exists"; CONTAINER_EXISTS=true; } || { echo >&2 "container $CONTAINER does NOT exists."; CONTAINER_EXISTS=false; }
echo

echo " - Check if profile is assigned"
test $(./client "fabric:container-info $CONTAINER" 2>/dev/null  | grep "Profiles:" | grep "$FAB_PROFILE" | wc -l) -gt 0 && { echo "profile $FAB_PROFILE is assigned to $CONTAINER"; PROFILE_ASSIGNED=true;  } || { echo "Profile $FAB_PROFILE is not assigned to $CONTAINER"; PROFILE_ASSIGNED=false ; }
echo

echo " - Check if profile exists"
test $(./client "fabric:profile-list" 2>/dev/null  | grep "$FAB_PROFILE" | wc -l) -gt 0 && { echo "profile $FAB_PROFILE exists"; PROFILE_EXISTS=true;  } || { echo "profile $FAB_PROFILE does not exist"; PROFILE_EXISTS=false ; }
echo

if [ "$CONTAINER_EXISTS" = true -a "$CONTAINER" != "root" ] ; then
    echo " - Deleting container $CONTAINER"
    sh client -r 2 -d 10 "fabric:container-delete $CONTAINER" 2>/dev/null
elif [ "$PROFILE_ASSIGNED" = true ] ; then
    echo " - Removing profile $FAB_PROFILE from $CONTAINER"
    sh client -r 2 -d 10 "fabric:container-remove-profile $CONTAINER $FAB_PROFILE" 2>/dev/null
fi

if [ "$PROFILE_EXISTS" = true ] ; then
    echo " - Deleting profile $FAB_PROFILE"
    sh client -r 2 -d 10 "fabric:profile-delete $FAB_PROFILE" 2>/dev/null
fi

popd > /dev/null
