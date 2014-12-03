#!/bin/sh

USER_DATA="/tmp/dnsstat";

DDNSSTAT=`head -n 1 $USER_DATA | tail -n 1 | cut -d= -f2-`;
DOMAIN_NAME=`head -n 2 $USER_DATA | tail -n 1 | cut -d= -f2-`;
OUTIP=`head -n 3 $USER_DATA | tail -n 1 | cut -d= -f2-`;
LEVEL=`head -n 4 $USER_DATA | tail -n 1 | cut -d= -f2-`;

declare_ddns_map()
{
   case "$1" in
  "DDNS_STATE_STOP")
		echo "未登录"
		return 0;;
  "DDNS_STATE_START")
		echo "正在连接中……"
		return 0;;
  "DDNS_STATE_CONNECT_FAILED")
		echo "连接失败，请检查你的Internet连接"
		return 0;;
  "DDNS_STATE_AUTH_FAILED")
		echo "认证失败，请核对你的帐号信息重新输入"
		return 0;;
  "DDNS_STATE_INPUT_ERR")
		echo "输入不完整，请核对你的帐号信息重新输入"
		return 0;;
  "DDNS_STATE_OK")
		echo "正在激活....   "
		return 0;;
  "DDNS_STATE_CONNECTED_OK")
		echo "连接成功"
		return 0;;
  "DDNS_STATE_KEEPALIVE_OK")
		echo "激活成功"
		return 0;;
  "DDNS_STATE_KEEPALIVE_ER")
		echo "保活丢包，网络状况异常"
		return 0;;
  "DDNS_STATE_REDIRECTING")
		echo "重定向服务器中……"
		return 0;;
  "DDNS_STATE_RECONNECTING")
		echo"重新连接中……"
		return 0;;
	esac
}

declare_ddns_level_map()
{
  case "$1" in

  "UNKNOWN")
	echo "未知"
	return 0;;
  "FREE")
	echo "免费级"
	return 0;;
  "PRO")
	echo "专业级"
	return 0;;
  "BIZ")
	echo "商业级"
	return 0;;
  "PRM")
	echo "旗舰级"
	return 0;;
  esac


}

info1=`declare_ddns_map "$DDNSSTAT"`
info2=`declare_ddns_level_map "$LEVEL"`

echo $info1 > /tmp/tem
echo $info2 >> /tmp/tem
echo $OUTIP >> /tmp/tem
echo $DOMAIN_NAME >> /tmp/tem
 
