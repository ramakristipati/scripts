#!/bin/bash

. $HOME/.aws.cfg

chmod 400 $AWS_PEM

SRC=$2
DST=$3

rsync -rave "ssh -i $AWS_PEM" $SRC/* ubuntu@$AWS_IP:$DST

