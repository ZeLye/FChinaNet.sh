#! /bin/bash

AUTH=""
# if AUTH == "" ; then
#  return
# fi

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.104 Safari/537.36"

# user_id
ID=$(curl -sS "https://www.loocha.com.cn:8443/login/" \
  --user $AUTH \
  --user-agent "$UA" \
  | grep -Eo '\"id\":\"[0-9]{7}\"' | awk -F: '{print $2}' | sed 's/"//g')
echo "user id:" $ID

# CODE
CODE=$(curl -sS "https://wifi.loocha.cn/${ID}/wifi/telecom/pwd?type=4" \
  --user $AUTH \
  | grep -Eo '\"password\":\"[0-9]{6}\"' | awk -F: '{print $2}' | sed 's/"//g')

echo "code: "$CODE

# wan_ip/bras_ip
# curl -sSI "http://test.f-young.cn/"
