#!/bin/bash

WS=stage
IPK8S=84.201.149.223

ssh -o "StrictHostKeyChecking no" ubuntu@$IPK8S "sudo cp /root/.kube/config /home/ubuntu/config; sudo chown ubuntu /home/ubuntu/config"
scp ubuntu@$IPK8S:/home/ubuntu/config "/root/.kube/config.${WS}"

