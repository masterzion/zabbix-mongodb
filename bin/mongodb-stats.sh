#!/bin/bash
# Date:                 22/01/2017
# Author:               Long Chen
# Description:          A script to send MongoDB stats to zabbix server by using zabbix sender
# Requires:             Zabbix Sender, zabbix-mongodb.py

# Last update:          Jairo Moreno
# Date:                 04/01/2018

HOST_ALIAS=$HOSTNAME #it may change

get_MongoDB_metrics(){
python /usr/local/bin/zabbix-mongodb.py 
}

# Send the results to zabbix server by using zabbix sender
result=$(get_MongoDB_metrics | /bin/zabbix_sender  -s $HOST_ALIAS -c /etc/zabbix/zabbix_agentd.conf -i - 2>&1)
response=$(echo "$result" | awk -F ';' '$1 ~ /^info/ && match($1,/[0-9].*$/) {sum+=substr($1,RSTART,RLENGTH)} END {print sum}')
if [ -n "$response" ]; then
        echo "$response"
else
        echo "$result"
fi
