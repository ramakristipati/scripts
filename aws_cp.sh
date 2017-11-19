#!/bin/bash

. $HOME/.aws.cfg

chmod 400 $AWS_PEM
sftp -i $AWS_PEM ubuntu@$AWS_IP

