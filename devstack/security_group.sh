#!/bin/sh

# 创建BOSH security group，允许bosh访问
nova secgroup-create bosh "security group for bosh access"
nova secgroup-add-rule bosh udp 53 53 0.0.0.0/0
nova secgroup-add-rule bosh tcp 4222 4222 0.0.0.0/0
nova secgroup-add-rule bosh udp 68 68 0.0.0.0/0
nova secgroup-add-rule bosh tcp 25555 25555 0.0.0.0/0
nova secgroup-add-group-rule bosh bosh tcp 1 65535
nova secgroup-add-rule bosh tcp 6868 6868 0.0.0.0/0
nova secgroup-add-rule bosh tcp 53 53 0.0.0.0/0
nova secgroup-add-rule bosh tcp 25250 25250 0.0.0.0/0
nova secgroup-add-rule bosh tcp 25777 25777 0.0.0.0/0

#创建security group， 允许SSH 访问
nova secgroup-create ssh "security group for ssh access"
nova secgroup-add-rule ssh icmp -1  -1  0.0.0.0/0
nova secgroup-add-rule ssh tcp 22 22 0.0.0.0/0
nova secgroup-add-rule ssh udp 68 68  0.0.0.0/0

#创建Cloudfoundry内网security group
nova secgroup-create cf-private "cf internal security group"
nova secgroup-add-rule cf-private udp 68 68 0.0.0.0/0
nova secgroup-add-rule cf-private udp 3456 3456 0.0.0.0/0
nova secgroup-add-group-rule cf-private bosh tcp 1 65535



# microbes keypair
nova keypair-add microbosh > microbosh.cer
chmod 400 microbosh.cer