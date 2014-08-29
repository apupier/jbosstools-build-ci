#!/bin/bash

stream=4.2.luna
branch=4.2.x

for j in aerogear arqullian base birt browsersim central forge freemarker hibernate javaee jst livereload openshift portlet server vpe webservices; do
  echo "== ${j} =="
  githash=`wget -q https://api.github.com/repos/jbosstools/jbosstools-${j}/commits/jbosstools-${branch} -O - | head -2 | grep sha | \
  	sed "s#  \"sha\": \"\(.\+\)\",#\1 (${branch})#"`
  jenkinshash=`wget -q http://download.jboss.org/jbosstools/builds/staging/jbosstools-${j}_${stream}/logs/GIT_REVISION.txt -O - | grep jbosstools | \
  	sed "s#\(.\+\)\@\(.\+\)#\2 (${stream}, \1)#"`
  if [[ ! ${jenkinshash} ]]; then
    echo "ERROR: branch $branch does not exist" | egrep ERROR
  elif [[ ${githash%% *} == ${jenkinshash%% *} ]]; then # match
  	echo "PASS: ${jenkinshash}"
  else
  	echo "FAIL:" | grep FAIL
  	echo "      $jenkinshash"
  	echo "      $githash"
  fi
  echo ""
done

stream=8.0.luna
for j in product; do
  echo "== ${j} =="
  githash=`wget -q https://api.github.com/repos/jbdevstudio/jbdevstudio-${j}/commits/jbosstools-${branch} -O - | head -2 | grep sha | \
    sed "s#  \"sha\": \"\(.\+\)\",#\1 (${branch})#"`
  jenkinshash=`wget -q http://www.qa.jboss.com/binaries/RHDS/builds/staging/devstudio.${j}_${stream}/logs/GIT_REVISION.txt -O - | grep jbosstools | \
    sed "s#\(.\+\)\@\(.\+\)#\2 (${stream}, \1)#"`
  if [[ ! ${jenkinshash} ]]; then
    echo "ERROR: branch $branch does not exist" | egrep ERROR
  elif [[ ${githash%% *} == ${jenkinshash%% *} ]]; then # match
    echo "PASS: ${jenkinshash}"
  else
    echo "FAIL:" | grep FAIL
    echo "      $jenkinshash"
    echo "      $githash"
  fi
  echo ""
done

