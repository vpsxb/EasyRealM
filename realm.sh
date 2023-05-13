#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear

sh_ver="1.0.0"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
realm_conf_path="/etc/realm/config.toml"
#检测是否安装RealM
check_status(){
    if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.toml;then
        echo "------------------------------"
        echo -e "--------${Green_font_prefix} RealM已安装~ ${Font_color_suffix}--------"
        echo "------------------------------"
    else
        echo "------------------------------"
        echo -e "--------${Red_font_prefix}RealM未安装！${Font_color_suffix}---------"
        echo "------------------------------"
    fi
}

#安装RealM
Install_RealM(){
  if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.toml;then
  echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
  echo -e "≡≡≡≡≡≡ ${Green_font_prefix}RealM已安装~ ${Font_color_suffix}≡≡≡≡≡≡"
  echo "≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"
  sleep 2s
  start_menu
  fi
  last_version=$(curl -Ls "https://api.github.com/repos/zhboner/realm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  echo -e "检测到 RealM 最新版本：${last_version}，开始安装"
  if [[ ! -n "$last_version" ]]; then
    echo -e "${red}检测 realm 版本失败，可能是超出 Github API 限制，请稍后再试，或手动指定 realm 版本安装${plain}"
    exit 1
  fi
  echo -e "#############################################################"
  echo -e "#    请选择下载点:  1.国外   2.国内                           #"
  echo -e "#############################################################"
  read -p "请选择(默认国外): " download
  [[ -z ${download} ]] && download="1"
  if [[ ${download} == [2] ]]; then
  echo -e "#############################################################"
  echo -e "#                     请选择下载版本:                        #"  
  echo -e "#    1.（realm_latest_gnu）   2.（realm_latest_musl）        #"
  echo -e "#############################################################"
  read -p "请选择(默认为gnu版): " version
  [[ -z ${version} ]] && version="1"
  if [[ ${version} == [2] ]]; then  
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://ghproxy.com/https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-musl.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  chmod +x /etc/realm/realm
  else
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://ghproxy.com/https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-gnu.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  chmod +x /etc/realm/realm
  fi  
  else
  echo -e "#############################################################"
  echo -e "#                     请选择下载版本:                       #"  
  echo -e "#    1.（realm_latest_gnu）   2.（realm_latest_musl）    #"
  echo -e "#############################################################"
  read -p "请选择(默认为gnu版): " version
  [[ -z ${version} ]] && version="1"
  if [[ ${version} == [2] ]]; then  
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-musl.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  chmod +x /etc/realm/realm
  else
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-gnu.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  chmod +x /etc/realm/realm
  fi
  fi
wget -N --no-check-certificate https://raw.githubusercontent.com/vpsxb/EasyRealM/main/config.toml -O /etc/realm/config.toml && chmod +x /etc/realm/config.toml
echo '
[Unit]
Description=realm
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
Type=simple
User=root
Restart=on-failure
RestartSec=5s
DynamicUser=true
ExecStart=/etc/realm/realm -c /etc/realm/config.toml

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/realm.service
systemctl enable --now realm
    echo "------------------------------"
    if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.toml;then
        echo -e "-------${Green_font_prefix} RealM安装成功! ${Font_color_suffix}-------"
        echo "------------------------------"
    else
        echo -e "-------${Red_font_prefix}RealM没有安装成功，请检查你的网络环境！${Font_color_suffix}-------"
        echo "------------------------------"
        `rm -rf "$(pwd)"/realm`
        `rm -rf "$(pwd)"/realm.service`
        `rm -rf "$(pwd)"/config.toml`
    fi
sleep 3s
start_menu
}

#卸载RealM
Uninstall_RealM(){
    if test -o /etc/realm/realm -o /etc/systemd/system/realm.service -o /etc/realm/config.toml;then
    sleep 2s
    `rm -rf /etc/realm`
    `rm -rf /etc/systemd/system/realm.service`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM卸载成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
    else
    echo -e "-------${Red_font_prefix}RealM没有安装,卸载个锤子！${Font_color_suffix}-------"
    sleep 3s
    start_menu
    fi
}
#启动RealM
Start_RealM(){
    if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.toml;then
    `systemctl start realm`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM启动成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
    else
    echo -e "-------${Red_font_prefix}RealM没有安装,启动个锤子！${Font_color_suffix}-------"    
    sleep 3s
    start_menu
    fi
}

#停止RealM
Stop_RealM(){
    if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.toml;then
    `systemctl stop realm`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM停止成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
    else
    echo -e "-------${Red_font_prefix}RealM没有安装,停止个锤子！${Font_color_suffix}-------"    
    sleep 3s
    start_menu
    fi
}

#重启RealM
Restart_RealM(){
    if test -a /etc/realm/realm -a /etc/systemd/system/realm.service -a /etc/realm/config.toml;then
    `systemctl restart realm`
    echo "------------------------------"
    echo -e "-------${Green_font_prefix} RealM重启成功! ${Font_color_suffix}-------"
    echo "------------------------------"
    sleep 3s
    start_menu
    else
    echo -e "-------${Red_font_prefix}RealM没有安装,重启个锤子！${Font_color_suffix}-------"    
    sleep 3s
    start_menu
    fi
}

#更新RealM
Update_RealM(){
  last_version=$(curl -Ls "https://api.github.com/repos/zhboner/realm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  echo -e "检测到 RealM 最新版本：${last_version}，开始安装"
  if [[ ! -n "$last_version" ]]; then
    echo -e "${red}检测 RealM 版本失败，可能是超出 Github API 限制，请稍后再试，或手动指定 RealM 版本安装${plain}"
    exit 1
  fi
  echo -e "#############################################################"
  echo -e "#    请选择下载点:  1.国外   2.国内                           #"
  echo -e "#############################################################"
  read -p "请选择(默认国外): " download
  [[ -z ${download} ]] && download="1"
  if [[ ${download} == [2] ]]; then
  echo -e "#############################################################"
  echo -e "#                     请选择下载版本:                        #"  
  echo -e "#    1.（realm_latest_gnu）   2.（realm_latest_musl）        #"
  echo -e "#############################################################"
  read -p "请选择(默认为gnu版): " version
  [[ -z ${version} ]] && version="1"
  if [[ ${version} == [2] ]]; then  
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://ghproxy.com/https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-musl.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  chmod +x /etc/realm/realm
  else
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://ghproxy.com/https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-gnu.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  chmod +x /etc/realm/realm
  fi  
  else
  echo -e "#############################################################"
  echo -e "#                     请选择下载版本:                       #"  
  echo -e "#    1.（realm_latest_gnu）   2.（realm_latest_musl）    #"
  echo -e "#############################################################"
  read -p "请选择(默认为gnu版): " version
  [[ -z ${version} ]] && version="1"
  if [[ ${version} == [2] ]]; then  
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-musl.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-musl.tar.gz
  chmod +x /etc/realm/realm
  else
  mkdir -p /etc/realm
  wget -N --no-check-certificate https://github.com/zhboner/realm/releases/download/${last_version}/realm-x86_64-unknown-linux-gnu.tar.gz -O /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  tar -zxvf /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz -C /etc/realm && rm /etc/realm/realm-x86_64-unknown-linux-gnu.tar.gz
  chmod +x /etc/realm/realm
  fi
  fi
  systemctl restart realm
}

#主菜单
start_menu(){
clear
echo
echo "#############################################################"
echo "#                 RealM 安装脚本  By vpsxb                  #"
echo "#############################################################"
#echo -e "公告：$(curl -L -s --connect-timeout 3 https://ghproxy.com/https://raw.githubusercontent.com/seal0207/EasyRealM/main/notice)"
echo -e "
 当前版本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
 ${Green_font_prefix}0.${Font_color_suffix} 更新realm
 ${Green_font_prefix}1.${Font_color_suffix} 安装 RealM
 ${Green_font_prefix}2.${Font_color_suffix} 卸载 RealM
——————————————
 ${Green_font_prefix}3.${Font_color_suffix} 启动 RealM
 ${Green_font_prefix}4.${Font_color_suffix} 停止 RealM
 ${Green_font_prefix}5.${Font_color_suffix} 重启 RealM
—————————————— "
check_status

read -p " 请输入数字后[0-11] 按回车键:
" num
case "$num" in
	1)
	Install_RealM
	;;
	2)
	Uninstall_RealM
	;;
	3)
	Start_RealM
	;;
	4)
	Stop_RealM
	;;	
	5)
	Restart_RealM
	;;
	0)
	Update_RealM
	;;
	*)	
	clear
	echo -e "${Error}:请输入正确数字 [0-11] 按回车键"
	sleep 2s
	start_menu
	;;
esac
}
start_menu