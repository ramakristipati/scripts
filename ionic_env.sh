#!/bin/bash

NODE_VERSION=8.9.1
NPM_VERSION=5.5.1
IONIC_VERSION=3.9.2
CORDOVA_VERSION=7.1.0

if [ -z "$(which curl)" ]; then
  sudo apt-get -y install curl
fi

# install nodejs and npm
if [ -z "$(which npm)" ]; then
  curl --retry 3 -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz"
  sudo tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 &&
  rm "node-v$NODE_VERSION-linux-x64.tar.gz"
  sudo npm install -g npm@"$NPM_VERSION"
  sudo npm install -g npm-check-updates
  sudo npm install --unsafe-perm  -g  level cordova-hot-code-push-cli
  sudo apt-get -y install apache2-utils
  sudo chown -R $USER:$(id -gn $USER) $HOME/.config
fi

#install ionic
if [ -z "$(which ionic)" ]; then
  sudo npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION"
  #sudo npm install -g ionic typings
fi

#install mongodb
if [ -z "$(dpkg -s mongodb-org | grep 'Status: install ok installed')" ]; then
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
  echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" \
   | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
fi

#start mongodb
if [ -z "$(service mongod status | grep running)" ]; then
  sudo service mongod start
  service mongod status
fi

#install android
. $(dirname $BASH_SOURCE)/android_env.sh

# set timezone
export TZ="Asia/Calcutta"
