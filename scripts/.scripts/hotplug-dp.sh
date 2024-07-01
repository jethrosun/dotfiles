#!/bin/bash

read STATUS_DP < /sys/class/drm/card1-eDP-1/status
read STATUS_HDMI < /sys/class/drm/card1-HDMI-A-1/status
#read STATUS_HDMI2 < /sys/class/drm/card0-HDMI-A-2/status
export DISPLAY=:0
#export XAUTHORITY=/home/jon/.Xauthority

maxlight() {
	/bin/cat /sys/class/backlight/intel_backlight/max_brightness > /sys/class/backlight/intel_backlight/brightness
}

lowdpi() {
	/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 96/' ~/.Xresources
	/usr/bin/sudo -E -u shwsun xrdb ~/.Xresources
}

hidpi() {
	/bin/sed -i 's/Xft.dpi: .*/Xft.dpi: 144/' ~/.Xresources
	/usr/bin/sudo -u shwsun xrdb ~/.Xresources
}

DEV=""
DEVC=""
STATUS="disconnected"
if [[ "$STATUS_HDMI" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI-1"
	DEVC="HDMI-A-1"
elif [[ "$STATUS_DP" = "connected" ]]; then
	STATUS="connected"
	DEV="eDP-1"
	DEVC="eDP-1"
elif [[ "$STATUS_HDMI2" = "connected" ]]; then
	STATUS="connected"
	DEV="HDMI-2"
	DEVC="HDMI-A-2"
fi

if [ "$STATUS" = "disconnected" ]; then
	/usr/bin/xrandr --output DP2 --off
	/usr/bin/xrandr --output HDMI-1 --off
	/usr/bin/xrandr --output HDMI-2 --off
	#/usr/bin/xrandr --output eDP-1 --mode 1920x1440
	/usr/bin/xrandr --output eDP-1 --auto
	#/usr/bin/xset +dpms
	#/usr/bin/xset s default
	#hidpi
	#/usr/bin/sed -i 's/HandleLidSwitch\=ignore/HandleLidSwitch\=suspend/' /etc/systemd/logind.conf
else
	if [[ $1 == "mirror" ]]; then
		#/usr/bin/xrandr --output $DEV --mode 1024x768
		#/usr/bin/xrandr --output eDP-1 --mode 1024x768 --same-as $DEV
		/usr/bin/xrandr --output $DEV --auto
		/usr/bin/xrandr --output eDP-1 --auto --same-as $DEV
	elif [[ $1 == "desktop" ]]; then
		/usr/bin/xrandr --output $DEV --auto
		/usr/bin/xrandr --output eDP-1 --off
	elif [[ $1 == "dual" ]]; then
		echo $DEV
		/usr/bin/xrandr --output $DEV --primary --auto
		/usr/bin/xrandr --output eDP-1 --auto --left-of $DEV
	else
		edid=$(/bin/cat /sys/class/drm/card0/card0-$DEVC/edid | /usr/bin/sha512sum - | /bin/sed 's/\s*-$//')
		printf $edid

    ## For some reasons it can only be top down
    pos="above"
    #pos="right-of"
    case "$edid" in
	    "9ed75b31c6f1bce5db7420887ebbc71c126d6a152ddf00b2b5bbb7a5479cea2608273bfcae23d8ec7bcf01578256d672c5fb0d899005f46096ef98dc447d2244")
		    pos="primary --rotate left --right-of"
		    maxlight
		    ;;
		    "2639dca257f1da0fecd2edf771aefae0347b56f2f2e51fb44802859d4b43e6b298b9d157bcb7a179de054435cf97d5af674244d6139319a36a1f58791d392a7e"|\
			    "e0b1346dd753a490b1d067e6b91acb40b52f67572799f6b7629484a167879248a7550496f85f62a91ea8c3cd96ddbb8cb6e30cba2effa645f225cd22667a278a")
						pos="primary --right-of"
						maxlight
						;;
				esac
				#/usr/bin/xrandr --addmode eDP-1 1920x1080
				/usr/bin/xrandr --output eDP1 --auto
				/usr/bin/xrandr --output $DEV --auto --$pos eDP1
	fi
	#/usr/bin/xset -dpms
	#/usr/bin/xset s off

  #/usr/bin/xrandr --dpi 96
  #lowdpi

  #/bin/sed -i 's/HandleLidSwitch\=suspend/HandleLidSwitch\=ignore/' /etc/systemd/logind.conf
fi

# notify-osd doesn't need to be restored
/usr/bin/pkill notify-osd
/usr/bin/sudo -E -u shwsun nitrogen --restore
/usr/bin/sudo -E -u shwsun /home/shwsun/.config/polybar/launch.sh
# /usr/bin/sudo -E -u shwsun /home/shwsun/bin/touchpad-setup.sh
# /usr/bin/systemctl restart systemd-logind
