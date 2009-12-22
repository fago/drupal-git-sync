#!/bin/bash
# Uses "cvs-sync" to sync with CVS and then pushes the changes to github.

cd `dirname $0`
# Include our configuration options.
. ./drupal_sync.conf

LIST="entity rules"
./sync-cvs $LIST

for module in $LIST
do
  cd $GITSRV/$module
  git push origin :
done


