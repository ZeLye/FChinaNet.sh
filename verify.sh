#! /bin/bash

AUTH=":"
if [ "x$AUTH" == "x:" ] ; then
  echo "[!] 请按照AUTH=\"user:pass\"格式填入掌上大学账户和密码！"
  exit
fi

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.104 Safari/537.36"

# 获取用户ID
ID=$(curl -sS "https://www.loocha.com.cn:8443/login/" \
  --user $AUTH \
  --user-agent "$UA" \
  | grep -Eo '\"id\":\"[0-9]{7}\"' | awk -F: '{print $2}' | sed 's/"//g')
echo "id: " $ID

# 获取随机密码CODE
CODE=$(curl -sS "https://wifi.loocha.cn/${ID}/wifi/telecom/pwd?type=4" \
  --user $AUTH \
  --user-agent "$UA" \
  | grep -Eo '\"password\":\"[0-9]{6}\"' | awk -F: '{print $2}' | sed 's/"//g')

echo "code: " $CODE

# 获取 WAN_IP 和 BRAS_IP
LOCATION=$(curl http://test.f-young.cn -sSI | grep -E 'Location')
WAN_IP=$(echo $LOCATION | awk -F '[:?&]' '{print $4}' | awk -F= '{print $2}')
BRAS_IP=$(echo $LOCATION | awk -F '[:?&]' '{print $5}'| awk -F= '{print $2}')

echo "wan_ip: " $WAN_IP
echo "bras_ip: " $BRAS_IP

# 获取 QRCODE
QRCODE=$(curl -sS "https://wifi.loocha.cn/0/wifi/qrcode?brasip=${BRAS_IP}&ulanip=${WAN_IP}&wlanip=${WAN_IP}" \
  | grep -Eo 'HIWF://[a-z0-9]{32}')

echo "qrcode: " $QRCODE

# 开始登录
PARAM="qrcode=${QRCODE}&code=${CODE}&type=1"

curl -X POST \
     --user $AUTH \
     --user-agent "$UA" \
     "https://wifi.loocha.cn/${ID}/wifi/telecom/auto/login?${PARAM}"
