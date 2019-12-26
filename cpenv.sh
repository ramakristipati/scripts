#!/bin/bash

version=$(date +%Y-%m-%d-%H-%M-%S)

cp -f $HOME/.vimrc $HOME/.vimrc.$version
cp -f $HOME/.bashrc $HOME/.bashrc.$version
cp -f $HOME/.bash_aliases $HOME/.bash_aliases.$version

cp $(dirname $0)/env/vimrc $HOME/.vimrc
cp $(dirname $0)/env/bashrc $HOME/.bashrc
cp $(dirname $0)/env/aliases $HOME/.bash_aliases
sudo cp $(dirname $0)/env/mod-etc-issue /etc/network/if-up.d/


