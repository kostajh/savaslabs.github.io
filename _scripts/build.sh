#!/bin/bash

# Enable error reporting to the console.
set -e

teleconsole
sleep 600

# Install bundles if needed
bundle check || bundle install

# NPM install if needed.
npm install

# Build the site.
gulp

ls -la _site
ls -la /tmp

# Stash built site.
cp -a _site /tmp/
cp .travis.yml /tmp/.travis.yml

# Checkout master and remove everything
git config user.email ${GH_EMAIL}
git config user.name "savas-bot"
git checkout master
rm -rf *

# Copy generated HTML site from source branch in original repo.
# Now the master branch will contain only the contents of the _site directory.
cp -R /tmp/_site/* .

# Make sure we have the updated .travis.yml file so tests won't run on master.
cp /tmp/.travis.yml .

# Commit and push generated content to master branch.
git status
git add -A .
git status
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
ls -la
git log --patch
# TODO: Uncomment when ready.
# git push --quiet origin master > /dev/null 2>&1
