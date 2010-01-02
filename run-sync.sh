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

  cd $GITSRV/$module.cvs
  echo "Synch git-cvs from $module..."
  git push $QUIET --all -f ../$module.git

  cd $GITSRV/$module.git
  echo "Pulling $module from origin..."
  git fetch $QUIET origin

  echo "Rebasing branches for $module..."
  for branch in `ls .git/refs/remotes/origin/`; do
    git checkout $QUIET $branch
    git rebase $QUIET origin/$branch
  done

  echo "Pushing $module to origin..."
  git push --all origin $QUIET
  git push --tags origin $QUIET
  cd ../..
done
