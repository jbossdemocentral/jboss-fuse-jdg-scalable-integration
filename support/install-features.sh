#!/bin/bash
basedir=`dirname $0`

FAB_PROFILE=demo-stock_ticker_integration
CONTAINER=stock-ticker
CLIENT_CMD="$basedir/../target/jboss-fuse*/bin/client -r 4 -d 10"

#Check if fuse is running stop it
echo "  - Checking that JBos Fuse is running..."
test $(jps -lm | grep karaf | grep -v grep | wc -l) -gt 0 && echo "JBoss Fuse is running " || { echo >&2 "JBoss Fuse is NOT started... aborting."; exit 1; }

echo

# Build the projects
echo "  - building the stock-ticker project"
echo
pushd $basedir/../projects/stock-ticker > /dev/null
mvn -q clean install > /dev/null 2>&1 || { echo >&2 "Failed to build the project.. Aborting"; exit 2; }

pushd stock-ticker-ploter > /dev/null
mvn -q assembly:assembly > /dev/null 2>&1 || { echo >&2 "Failed to assembly the client.. Aborting"; exit 2; }
popd > /dev/null
popd > /dev/null


if test $($CLIENT_CMD "fabric:profile-display default" 2>/dev/null | grep "org.ops4j.pax.url.mvn.repositories" | grep "id=techpreview-all-repository" | wc -l ) -eq 0; then
  $CLIENT_CMD "fabric:profile-edit --pid io.fabric8.agent/org.ops4j.pax.url.mvn.repositories='http://maven.repository.redhat.com/techpreview/all@id=techpreview-all-repository' default" 2>/dev/null
fi

if test $($CLIENT_CMD "fabric:profile-display default" 2>/dev/null | grep "mvn:org.apache.camel/camel-jbossdatagrid/6.4.1.Final-redhat-2/xml/features" | wc -l) -eq 0; then
  $CLIENT_CMD "fabric:profile-edit --repositories mvn:org.apache.camel/camel-jbossdatagrid/6.4.1.Final-redhat-2/xml/features default" 2>/dev/null
fi

if test $($CLIENT_CMD "fabric:profile-display default" 2>/dev/null | grep "mvn:org.jboss.demo.jdg/stock-ticker-features/1.0.0/xml/features" | wc -l) -eq 0; then
  $CLIENT_CMD "fabric:profile-edit --repositories mvn:org.jboss.demo.jdg/stock-ticker-features/1.0.0/xml/features default" 2>/dev/null
fi

#sh client -r 2 -d 10 "fabric:profile-edit --repositories mvn:org.jboss.demo.jdg/stock-ticker-features/1.0.0/xml/features default"

#
echo " - Checking if profile $FAB_PROFILE exists"
if test $($CLIENT_CMD "fabric:profile-list" 2>/dev/null | grep "$FAB_PROFILE" | wc -l) -eq 0; then
  echo
  echo " - Creating profile $FAB_PROFILE"
  $CLIENT_CMD "fabric:profile-create --parents feature-camel $FAB_PROFILE" 2>/dev/null && echo "profile $FAB_PROFILE is successfully created"
  $CLIENT_CMD "fabric:profile-edit --features mq-fabric-camel $FAB_PROFILE" 2>/dev/null
  $CLIENT_CMD "fabric:profile-edit --features stock-ticker-model $FAB_PROFILE" 2>/dev/null
  $CLIENT_CMD "fabric:profile-edit --features stock-ticker-integration $FAB_PROFILE" 2>/dev/null
  echo

  echo " - Checking that container $CONTAINER exists"
  if test $($CLIENT_CMD "fabric:container-list" 2>/dev/null | grep $CONTAINER | wc -l) -eq 1; then
    echo "container exists"
    echo
    echo " - Assigning profile $FAB_PROFILE to container $CONTAINER"
    $CLIENT_CMD -r 2 -d 10 "fabric:container-add-profile $CONTAINER $FAB_PROFILE" 2>/dev/null
    echo
  else
    echo "container $CONTAINER does NOT exist, creating it"
    $CLIENT_CMD "container-create-child --profile $FAB_PROFILE root $CONTAINER"
    echo
  fi
else
  echo "profile $FAB_PROFILE already exists, plrease remove it first"
  echo
  exit 2
fi
#sh client -r 2 -d 10 "fabric:version-create --parent 1.0 --default 1.1"

#sh client -r 2 -d 10 "fabric:profile-edit --features stock-ticker-model demo-stock_ticker_integration 1.0"

#sh client -r 2 -d 10 "fabric:profile-edit --features stock-ticker-integration demo-stock_ticker_integration 1.0"

#sh client -r 2 -d 10 "container-upgrade --all 1.1"

#sh client -r 2 -d 10 "container-create-child --profile demo-stock_ticker_integration root stock-ticker"
