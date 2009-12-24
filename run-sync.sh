#!/bin/bash
# Uses "cvs-sync" to sync with CVS and then pushes the changes to github.

cd `dirname $0`
# Include our configuration options.
. ./drupal_sync.conf

QUIET="-q"
if [ ! $VERBOSE = "0" ]; then
  QUIET=""
fi

LIST="entity rules"

for module in $LIST
do
  echo "Synching with cvs..."
  ./sync-cvs $module
  
  echo "Synching git cvs copy with git mirror..."
  cd $GITSRV/$module.cvs
  git push -f ../$module.git
  
  cd $GITSRV/$module.git
  echo "Pulling $module from origin..."
  git fetch origin $QUIET

  echo "Pushing $module to origin..."
  git push origin $QUIET
  cd ../..
done


