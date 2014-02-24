#!/bin/bash

echo ''
echo 'Please ignore mkdir file exists messages.'
# make needed folders
mkdir built
mkdir built/web
mkdir built/web/packages

echo ''
echo 'dart.js packages copy...'
# dart.js copy into packages
cp -R ./tool/include/browser ./built/web/packages

echo ''
echo 'resources copy...'
# copy of resources or dart native code (to be replaced by dart2dart compiler)
cp ./web/index.html ./built/web
cp -R ./web/assets ./built/web
cp -R ./web/docs ./built/web
cp -R ./web/source ./built/web

echo ''
echo 'building...'
# hop builder
exec dart --checked ./tool/hop_runner.dart "$@"
