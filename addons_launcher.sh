#!/bin/sh

LANG=ru_RU.UTF-8

####################
if ! [ -n "$1" ]; then
    clear
    echo 
    echo "   Укажите один из параметров: RDP, ONEC, CHROME, FIREFOX, WEBCAM, MP3, VIDEO, STOP, setup"
    echo "   Перед применением setup, внесите свои настройки в файле addons_launcher.sh"
    sleep 5
    exit 0
else
    if [ ! -f /home/tc/storage/3rd-party/addons_launcher/launcher_configured ] && [ "$1" != "setup" ]; then
	clear
	echo 
	echo "   Внесите свои настройки в файле addons_launcher.sh и выполните ./addons_launcher.sh setup"
	sleep 5
	exit 0
    fi
fi
####################

export DISPLAY=:0
DISPLAY=:0 xhost +box
DISPLAY=:0 xhost +SI:localuser:tc

. /etc/sysconfig/tcedir/storage/3rd-party/addons_launcher/launcher_functions

####################
#
# Включите или отключите дополнения:  ХХХ_ENABLE=1 - использовать, ХХХ_ENABLE=0 - не использовать
# и укажите необходимые параметры - ip, порт, логин, пароль для RDP и измените другие параметры
# для каждого дополнения, при необходимости.
#
####################
# RDP Config
####################
RDP_ENABLE=1 # 1 - Использовать RDP

RDP_PROG="xfreerdp"
if uname -a | grep -i tinycore ; then
    RDP_PROG="/usr/local/freerdp/bin/xfreerdp"
fi
RDP_IP="192.168.191.62"  # IP Сервера RDP, например "172.29.21.25"
RDP_PORT="3389" # Если не стандартный порт, изменить на нужный
RDP_DOMAIN="" # Домен Windows
RDP_USER="" # Логин
RDP_PASSWORD='' # Пароль, одинарные кавычки, если в пароле служебные символы
RDP_SEC="tls"  # Варианты: rdp tls nla или ext
RDP_ANY_COMMANDS="/cert-ignore /f /monitors:0 +clipboard"  # Любые дополнительные параметры, например: "/cert-ignore /f /monitors:0 +clipboard"
RDP_CMD="$RDP_PROG /v:$RDP_IP:$RDP_PORT /d:$RDP_DOMAIN /u:$RDP_USER /p:$RDP_PASSWORD /sec:$RDP_SEC $RDP_ANY_COMMANDS"

#####################
# 1C Config
#####################
ONEC_ENABLE=1 # 1 - Использовать 1C - тонкий клиент

ONEC_PROG="/opt/1cv8/common/1cestart"
ONEC_ANY_COMMANDS="" # Любые дополнительные параметры
ONEC_CMD="$ONEC_PROG $ONEC_ANY_COMMANDS"

#####################
# Chrome Config
#####################
CHROME_ENABLE=1 # 1 - Использовать Chromium браузер

CHROME_PROG="/opt/chromium-gost/chromium-gost --no-sandbox --disable-gpu --disable-software-rasterizer --disable-infobars --password-store=basic %U --start-maximized --check-for-update-interval=999999 --user-data-dir=/home/tc/storage/3rd-party/addons_launcher/tmp"
CHROME_ADDRESS="https://ut11.masterf.org" # например "ya.ru" или две вкладки "ya.ru google.ru"
CHROME_ANY_COMMANDS="" # Любые дополнительные параметры
CHROME_CMD="$CHROME_PROG  $CHROME_ANY_COMMANDS $CHROME_ADDRESS"

#####################
# FireFox Config
#####################
FOX_ENABLE=1 # 1 - Использовать Chromium браузер

FOX_PROG="/usr/bin/firefox" #
FOX_ADDRESS="ya.ru" # например "ya.ru" или две вкладки "ya.ru google.ru"
FOX_ANY_COMMANDS="" # Любые дополнительные параметры
FOX_CMD="$FOX_PROG $FOX_ANY_COMMANDS $FOX_ADDRESS"

#####################
# WebCam Config
#####################
WEBCAM_ENABLE=0 # 1 - Использовать WebCam

WEBCAM_PROG="/usr/local/bin/mplayer"
WEBCAM_WIDTH="640" # Ширина окна изображения
WEBCAM_HEIGHT="480" # Высота окна изображения
WEBCAM_DEV="/dev/video0" # Имя устройства, зависит от камеры
WEBCAM_FPS="30" # Частота кадров
WEBCAM_ANY_COMMANDS="" # Любые дополнительные параметры
WEBCAM_CMD="$WEBCAM_PROG tv:// -tv driver=v4l2:width=$WEBCAM_WIDTH:height=$WEBCAM_HEIGHT:device=$WEBCAM_DEV -fps $WEBCAM_FPS $WEBCAM_ANY_COMMANDS"

#####################
# MP3 Player Config
#####################
MP3_ENABLE=0 # 1 - Использовать MP3 плеер

MP3_PROG="/usr/local/bin/mpg123"
MP3_DIR="/home/tc/storage/playerctl/audio" # Каталог с файлами mp3
MP3_PLAYLIST="" # Имя файла рлейлиста, если пусто, то плейлист генерится автоматически
MP3_ANY_COMMANDS="" # Любые дополнительные параметры
MP3_CMD="$MP3_PROG $MP3_ANY_COMMANDS -@ $MP3_DIR/$MP3_PLAYLIST"

#####################
# Video Player Config
#####################
VIDEO_ENABLE=0 # 1 - Использовать Видео плеер

VIDEO_PROG="/usr/local/bin/cvlc"
VIDEO_DIR="/home/tc/storage/playerctl/video" # Каталог с файлами mp4 avi png jpg - создайте каталог и загрузите файлы перед использованием
VIDEO_PLAYLIST="" # Имя файла рлейлиста, если пусто, то плейлист генерится автоматически
VIDEO_WIDTH="1024" # Ширина окна изображения
VIDEO_HEIGHT="768" # Высота окна изображения
VIDEO_ANY_COMMANDS="--no-audio -f" # Любые дополнительные параметры например: "--no-loop --no-audio --crop 16:9 -f"
VIDEO_CMD="$VIDEO_PROG --reset-config --image-duration 5 --screen-follow-mouse --play-and-exit --no-video-title --autoscale --width=$VIDEO_WIDTH --height=$VIDEO_HEIGHT $VIDEO_ANY_COMMANDS $VIDEO_DIR/$VIDEO_PLAYLIST"

#####################
# STOP Config
#####################
STOP_ENABLE=1 # 1 - Использовать STOP

STOP_CMD=""

####################
# Keys Config - назначения клавиш
####################

# Внимание!!!
# При активном сеансе RDP, быстрые клавиши не работают!!! Либо завершите сеанс, либо
# однократно нажмите кнопку "правый Ctrl" ( right Ctrl ) на клавиатуре, затем нужную
# комбинацию, например:  right Ctrl, Ctrl+F1 - Переключение на Рабочий стол 1, в кассу
# или - right Ctrl, Ctrl+e - Выход на рабочий стол кассы
# или - right Ctrl, Ctrl+i - Быстрые клавиши для запуска браузера CHROME

WS1="OnDesktop Mouse1 :HideMenus"
WS2="OnDesktop Mouse2 :WorkspaceMenu"
WS3="OnDesktop Mouse3 :RootMenu"

WS4="Control F1 :Workspace 1" # Переключение на Рабочий стол 1
WS5="Control F2 :Workspace 2" # Переключение на Рабочий стол 2
WS6="Control F3 :Workspace 3" # Переключение на Рабочий стол 3
WS7="Control F4 :Workspace 4" # Переключение на Рабочий стол 3
WS8="Control F5 :Workspace 5" # Переключение на Рабочий стол 5

KEYS_CMD=':ExecCommand  /etc/sysconfig/tcedir/storage/3rd-party/addons_launcher/addons_launcher.sh'
UKEYS_CMD='/home/tc/storage/3rd-party/addons_launcher/addons_launcher.sh'

KEYS1="Control r $KEYS_CMD RDP > /dev/null"    # Быстрые клавиши для запуска RDP
UKEYS1="\"/commands/custom/<Primary><Control>r\" --create --type string --set \"$UKEYS_CMD RDP\""

KEYS2="Control i $KEYS_CMD CHROME > /dev/null" # Быстрые клавиши для запуска CHROME
UKEYS2="\"/commands/custom/<Primary><Control>i\" --create --type string --set \"$UKEYS_CMD CHROME\""

KEYS8="Control f $KEYS_CMD FIREFOX > /dev/null" # Быстрые клавиши для запуска FIREFOX
UKEYS8="\"/commands/custom/<Primary><Control>f\" --create --type string --set \"$UKEYS_CMD FIREFOX\""

KEYS3="Control w $KEYS_CMD WEBCAM > /dev/null" # Быстрые клавиши для запуска WEBCAM

KEYS4="Control m $KEYS_CMD MP3 > /dev/null"    # Быстрые клавиши для запуска MP3
KEYS5="Control b $KEYS_CMD VIDEO > /dev/null"  # Быстрые клавиши для запуска VIDEO

KEYS6="Control l $KEYS_CMD ONEC > /dev/null"  # Быстрые клавиши для запуска 1C тонкий клиент
UKEYS6="\"/commands/custom/<Primary><Control>l\" --create --type string --set \"$UKEYS_CMD ONEC\""

KEYS7="Control e :ExecCommand  wmctrl -s 0"    # Выход на рабочий стол кассы

# Принудительная остановка всех дополнительных приложений
#KEYS99="Control k :ExecCommand  sudo killall -9 vlc ; sudo killall -9 chromium ; sudo killall -9 mpg123 ; sudo killall -9 mplayer ; wmctrl -s 0"
#UKEYS99="\"/commands/custom/<Primary><Control>k\" --create --type string --set \"cash stop; sudo killall -9 chromium ; sudo killall -9 rdp ; wmctrl -s 0 ; cash start\""
KEYS99="Control k $KEYS_CMD STOP > /dev/null" 
UKEYS99="\"/commands/custom/<Primary><Control>k\" --create --type string --set \"$UKEYS_CMD STOP\""

####################
# Menu Config - меню Flushbox ( правая кнопка мыши )
####################

MENU_CMD='/etc/sysconfig/tcedir/storage/3rd-party/addons_launcher/addons_launcher.sh'

MENU1="[exec]   (RDP) {$MENU_CMD RDP}"
MENU2="[exec]   (Chrome) {$MENU_CMD CHROME}"
MENU3="[exec]   (WebCam) {$MENU_CMD WEBCAM}"
MENU4="[exec]   (Music) {$MENU_CMD MP3}"
MENU5="[exec]   (Video) {$MENU_CMD VIDEO}"

#####################
# End Config
#####################

start_prog $1

#####################
# Fetch Tabs from Server by @JaredFrost 06.12.2024
#####################

SERVER_URL="http://api.soft-bridge.ru/set/tabs" 

if [ "$1" = "CHROME" ] || [ "$1" = "FIREFOX" ]; then
    # Получаем список вкладок от сервера
    TABS_JSON=$(curl -s $SERVER_URL)
    if [ $? -ne 0 ] || [ -z "$TABS_JSON" ]; then
        echo "Ошибка: не удалось получить вкладки с сервера $SERVER_URL"
        exit 1
    fi

    # Извлекаем вкладки из JSON
    TABS=$(echo $TABS_JSON | jq -r '.tabs[]' | tr '\n' ' ')
    if [ -z "$TABS" ]; then
        echo "Ошибка: сервер не вернул корректный список вкладок."
        exit 1
    fi

    # Перезаписываем адреса вкладок для браузера
    if [ "$1" = "CHROME" ]; then
        CHROME_CMD="$CHROME_PROG $CHROME_ANY_COMMANDS $TABS"
        echo "Запускаем Chrome с вкладками: $TABS"
    elif [ "$1" = "FIREFOX" ]; then
        FOX_CMD="$FOX_PROG $FOX_ANY_COMMANDS $TABS"
        echo "Запускаем Firefox с вкладками: $TABS"
    fi
fi

