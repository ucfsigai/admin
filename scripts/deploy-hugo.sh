#!/bin/sh

#: exit on any fails
set -e

source activate sigai-auto-admin
python -m admin update --noteboks
python -m admin make --jekyll-posts

TARGET_BRANCH="gh-pages"

REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

#: here's the general process
#: /jenkins
#: +--- /<data-science | intelligence>
#: +--- +--- /docs
#:           | ^ the site is located here
#:           +--- /_site
#:                | ^ jekyll builds the site here

rm -rf .git
cd docs
bundle install
bundle exec jekyll b --future
cd _site
git init
git remote add origin $SSH_REPO
git checkout --orphan gh-pages

git config user.name ""
git config user.email "travis-ci@ucfsigai.org"

git add .
git commit -m "Deploying ${SHA} to GitHub Pages"

git push --force origin $TARGET_BRANCH

#: considering hugo, which uses go
#: https://github.com/gohugoio/hugo/releases/latest