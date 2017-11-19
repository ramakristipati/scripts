#!/bin/bash

. $HOME/.aws.cfg

chmod 400 $AWS_PEM
ssh -i $AWS_PEM ubuntu@$AWS_IP

