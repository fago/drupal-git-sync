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
./sync-cvs $LIST

for module in $LIST
do
  cd $GITSRV/$module
  echo "Pushing $module to origin..."
  # We don't use --mirror by default, so additonal branches not in CVS
  # are not removed.
  git push origin $QUIET --all
  git push origin $QUIET --tags
done


