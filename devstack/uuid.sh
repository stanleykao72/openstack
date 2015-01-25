#!/bin/sh
nova secgroup-list
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-add-rule default udp 53 53 0.0.0.0/0



DEMO_TENANT_ID=`keystone tenant-list | grep " demo " | cut -d "|" -f 2 | tr -d ' '`
NEUTRON_SECGRP=`neutron security-group-list -f csv --quote none | grep default | cut -d "," -f 1`
for g in $NEUTRON_SECGRP
do
  neutron security-group-show $g | grep -q $DEMO_TENANT_ID
  if [ $? -eq 0 ]
  then
    # echo $g
    export SECGRP_ID=$g
  fi
done

neutron security-group-rule-create --protocol icmp --direction ingress $SECGRP_ID
neutron security-group-rule-create --protocol icmp --direction egress $SECGRP_ID
neutron security-group-rule-create --protocol tcp --port-range-min 1 --port-range-max 65535 --direction ingress $SECGRP_ID
neutron security-group-rule-create --protocol tcp --port-range-min 1 --port-range-max 65535 --direction egress $SECGRP_ID
neutron security-group-rule-create --protocol udp --port-range-min 1 --port-range-max 65535 --direction ingress $SECGRP_ID
neutron security-group-rule-create --protocol udp --port-range-min 1 --port-range-max 65535 --direction egress $SECGRP_ID
