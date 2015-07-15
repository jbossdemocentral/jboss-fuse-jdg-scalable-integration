#!/bin/bash
basedir=$(dirname $0)
java -jar $basedir/projects/stock-ticker/stock-ticker-ploter/target/stock-ticker-ploter-1.0.0-jar-with-dependencies.jar > /dev/null 2>&1 &
