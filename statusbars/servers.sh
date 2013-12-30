#!/bin/bash

# figure out if we are at home or elsewhere

ARCHWAYUP="no"

NETWORK=$(netctl list | sed -n 's/^\* //p')
if [[ -z "$NETWORK" ]]; then
  NETWORK="$(wpa_cli -i wlan0 status | sed -n 's/^id_str=//p')"
fi

if [[ "$NETWORK" == "dcnet2" ]] || \
  ( [[ "$NETWORK" == "eth" ]] && \
  ping -c1 -w1 192.168.1.1 2> /dev/null ); then

  HOST=archway
  SSHPORT=22

else
  HOST=darkc.no-ip.org
  SSHPORT=62
  
fi

TEXT=""

if [[ "archway" != "$(curl -s http://$HOST/isarchway)" ]]; then
  TEXT+="^low()archway^norm()"
else
  TEXT+="^norm()archway"
  ARCHWAYUP="yes"
fi

if [[ "$ARCHWAYUP" == "yes" ]]; then
  vms=$(ssh -i ~/.ssh/id_rsa_vboxinspector vboxinspector@$HOST -p $SSHPORT \
    "sudo /var/vboxinspector/listvms.sh" | cut -d'"' -f2 | tr '\n' ' ' | \
    sed -r 's/(^ *)|( *$)//g' )

  if echo $vms | grep "win2008" &> /dev/null; then
    TEXT+="#^norm()fshost"
  else
    TEXT+="#^low()fshost^norm()"
  fi

  if echo $vms | grep "win8" &> /dev/null; then
    TEXT+="#^norm()win8"
  else
    TEXT+="#^low()win8^norm()"
  fi

fi

echo "text servers $TEXT"
