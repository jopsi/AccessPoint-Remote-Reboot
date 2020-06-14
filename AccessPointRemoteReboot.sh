#!/bin/bash
RECHNER="$1"
USERNAME="admin"
PASSWORD="password"
if [ ! -z $2 ]; then
    USERNAME=$2
fi
if [ ! -z $3 ]; then
    PASSWORD=$3
fi

function rebootNetGearWG602v4() {
    RECHNER=$1
    USRNM=$2
    PSSWRD=$3
    wget --http-user=$USRNM --http-passwd=$PSSWRD -O - http://$RECHNER/cgi-bin/reboot.cgi?reboot_ap=1
    wget --http-user=$USRNM --http-passwd=$PSSWRD -O - http://$RECHNER/cgi-bin/logout.html
}

function rebootTPLineWA801ND() {
    RECHNER=$1
    echo -e "[ACT_REBOOT#0,0,0,0,0,0#0,0,0,0,0,0]0,0\\r\\n" > /tmp/$0.data
    local USRPWDB64="Basic $(echo -n "test:test" | base64)"
    curl -s -D "/tmp/$0.respHead"\
       -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36"\
       -H "DNT: 1"\
       -H "Connection: keep-alive"\
       -H "Referer: http://$RECHNER/mainFrame.htm"\
       -H "Origin: http://$RECHNER"\
       --cookie "Authorization=\"$USRPWDB64\""\
       --data-binary "@/tmp/$0.data" --url "http://$RECHNER/cgi?7"
    echo -n "Return Code: "
    grep "HTTP" /tmp/$0.respHead
}

rebootTPLineWA801ND "$RECHNER"
rm /tmp/$0.*
