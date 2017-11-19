#!/bin/bash

tmpFile=$(mktemp)

ANDROID_HOME=/opt/android-sdk-linux
ANDROID_SDK_VERSION=24.4.1
GRADLE_VERSION=4.3

# create license accept file
cat << EOF > $tmpFile
#!/usr/bin/expect -f

set timeout 1800
set cmd [lindex \$argv 0]
set licenses [lindex \$argv 1]

spawn {*}\$cmd
expect {
  "Do you accept the license '*'*" {
        exp_send "y\r"
        exp_continue
  }
  eof
}
EOF

if [ -z "$(which java)" ]; then
  # install java8
  sudo apt-get update && sudo apt-get install -y -q python-software-properties software-properties-common
  sudo add-apt-repository ppa:webupd8team/java -y
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
  sudo apt-get update && sudo apt-get -y install oracle-java8-installer
fi

if [ ! -f ${ANDROID_HOME}/tools/android-accept-licenses.sh ]; then
  # instance android SDK dependencies
  echo ANDROID_HOME="${ANDROID_HOME}" | sudo tee --append /etc/environment
  sudo dpkg --add-architecture i386
  sudo apt-get update && sudo apt-get install -y --force-yes expect ant wget zipalign libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod

  # download android SDK
  pushd /opt
    sudo wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r"$ANDROID_SDK_VERSION"-linux.tgz
    sudo tar xzf android-sdk.tgz && sudo rm -f android-sdk.tgz*
  popd

  # copy license accept file
  sudo cp -f $tmpFile ${ANDROID_HOME}/tools/android-accept-licenses.sh
  sudo chmod +x ${ANDROID_HOME}/tools/android-accept-licenses.sh

  # install android SDK
  pushd /opt
    FILTER="platform-tools,tools"
    FILTER="$FILTER,build-tools-26.0.0,android-26"
    FILTER="$FILTER,build-tools-25.0.0,android-25"
    FILTER="$FILTER,extra-android-support,extra-android-m2repository,extra-google-m2repository"
    sudo ${ANDROID_HOME}/tools/android-accept-licenses.sh "${ANDROID_HOME}/tools/android update sdk --all --no-ui --filter $FILTER"
    sudo unzip ${ANDROID_HOME}/temp/*.zip -d ${ANDROID_HOME}
  popd

  # install gradle
  pushd /opt
    sudo wget --output-document=gradle-bin.zip --quiet https://services.gradle.org/distributions/gradle-"$GRADLE_VERSION"-bin.zip
    sudo mkdir -p /opt/gradle && sudo unzip -d /opt/gradle gradle-bin.zip && sudo rm -rf gradle-bin.zip*
  popd

fi

# set environment
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:/opt/gradle/gradle-"$GRADLE_VERSION"/bin

#apt-get install -y git wget curl unzip ruby ruby-dev gcc make

# cleanup
rm -f $tmpFile
