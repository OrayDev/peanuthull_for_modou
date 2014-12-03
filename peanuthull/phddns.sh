#!/bin/sh

CURWDIR=$(cd $(dirname $0) && pwd)
CUSTOMCONF="$CURWDIR/custom.conf"
SETCONF="$CURWDIR/config-file.conf"
USER_DATA="/tmp/tem"
CUSTOM_PID="`cat /var/run/custom.pid`"
SHOWCONF="$CURWDIR/show.conf"

DDNSSTAT=`head -n 1 $USER_DATA | tail -n 1 | cut -d ' ' -f2-`
DOMAIN_NAME=`head -n 4 $USER_DATA | tail -n 1 | cut -d ' ' -f2-`;
OUTIP=`head -n 3 $USER_DATA | tail -n 1 | cut -d ' ' -f2-`;
LEVEL=`head -n 2 $USER_DATA | tail -n 1 | cut -d ' ' -f2-`;


USERID=`head -n 1 $SETCONF | cut -d ' ' -f2-`;
PASSWORD=`head -n 2 $SETCONF | tail -n 1 | cut -d ' ' -f2-`;


CMDHEAD='"cmd":"'
CMDTAIL='",'
SHELLBUTTON1="$CURWDIR/phddns.sh config"
SHELLBUTTON2="$CURWDIR/phddns.sh start"
SHELLBUTTON3="$CURWDIR/phddns.sh show"
CMDBUTTON1=${CMDHEAD}${SHELLBUTTON1}${CMDTAIL};
CMDBUTTON2=${CMDHEAD}${SHELLBUTTON2}${CMDTAIL};
CMDBUTTON3=${CMDHEAD}${SHELLBUTTON3}${CMDTAIL};
genCustomConfig()
{
    echo '
    {
        "title": "花生壳",
        "content": "花生壳是一套完全免费的动态域名解析服务客户端软件.1、配置用户名和密码，2、点击[登录]启用花生壳,3、点击[查看]显示登录信息",
        "button1": {
    ' > $CUSTOMCONF
    echo $CMDBUTTON1 >> $CUSTOMCONF
    echo '
            "txt": "配置",
            "code": {"0": "配置用户名密码成功，请点击登录", "-1": "配置用户名密码失败"}
            },
        "button2": {
    ' >>$CUSTOMCONF
    echo $CMDBUTTON2 >> $CUSTOMCONF
    echo '
            "txt": "登录",
            "code": {"0": "登录成功.点击[查看]可显示(刷新)当前用户登录的状态信息", "-1": "登录失败"}
            },
    	"button3":{

    ' >> $CUSTOMCONF
    echo $CMDBUTTON3 >> $CUSTOMCONF
    echo '
	    "txt": "查看",
	    "code": {"0": "success", "-1": "fail"}
	   }
    }
    ' >> $CUSTOMCONF
    return 0;
}

phddnsTpStart()
{
    genCustomConfig;
    custom $CUSTOMCONF&
    echo $! > /var/run/custom.pid
    return 1;
}

phddnsConfig()
{
    generate-config-file $SETCONF
   # USERID=`head -n 1 $SETCONF | cut -d ' ' -f2-`;
   # PASSWORD=`head -n 2 $SETCONF | tail -n 1 | cut -d ' ' -f2-`;

}

genCustomConfigforShow()
{
    echo '
	{
        "title":"当前用户信息",' >$CUSTOMCONF
        ddnsstat='"content":"状态信息:'${DDNSSTAT}
        echo $ddnsstat >> $CUSTOMCONF
        level="用户级别:"${LEVEL}
        echo $level >>$CUSTOMCONF
        outip="公网IP:"${OUTIP}
        echo $outip >>$CUSTOMCONF
        domain_name="域名:"${DOMAIN_NAME}
        echo $domain_name >>$CUSTOMCONF
        echo '",' >> $CUSTOMCONF
    echo '
        "button1": {
    ' >> $CUSTOMCONF
    echo $CMDBUTTON1 >> $CUSTOMCONF
    echo '
            "txt": "配置",
            "code": {"0": "配置用户名密码成功，请点击登录", "-1": "配置用户名密码失败"}
            },
        "button2": {
    ' >>$CUSTOMCONF
    echo $CMDBUTTON2 >> $CUSTOMCONF
    echo '
            "txt": "登录",
            "code": {"0": "登录成功.点击[查看]可显示(刷新)当前用户登录的状态信息", "-1": "登录失败"}
            },
    	"button3":{

    ' >> $CUSTOMCONF
    echo $CMDBUTTON3 >> $CUSTOMCONF
    echo '
	    "txt": "查看",
	    "code": {"0": "", "-1": ""}
	   }
    }
    ' >> $CUSTOMCONF
    return 0;

}

phddnsStart()
{
    killall phddns 1>/dev/null 2>&1
    $CURWDIR/bin/phddns $USERID $PASSWORD &
}

phddnsShow()
{
    rm -rf   /tmp/tem
    $CURWDIR/parse.sh
    genCustomConfigforShow;
    kill -SIGUSR1 $CUSTOM_PID
}
# phddns.sh main
case "$1" in
    "tpstart")
        phddnsTpStart;
        exit 0;
        ;;
    "config")
        # do the config and get the input info
        phddnsConfig;
        ;;
    "show")
	#show user information
        phddnsShow;
	;;
    "start")
        # run the server
        phddnsStart;
        ;;
    *)
        ;;
esac

