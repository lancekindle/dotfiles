#! /bin/bash
# this script is run when the keyboard is plugged in, and it switches the
# keyboard layout to dvorak
HOME="/home/lancey"  # define home so that program is executed as user?

# scripts called by /etc/udev/rules.d/* MUST call an intermediate script that backgrounds the actual task. This script recursively backgrounds itself in order to 
if [[ $# == 0 ]]
then
    echo "no arguments except self file:"
    # run program again (in background: | at now), this time with an argument
    # must "disown" process so it doesn't get killed by udev
    echo $0 "x" | at now
    # exit so that file does not continue running
    exit
    echo "IF THIS TEXT APPEARS, SCRIPT IS MALFUNCTIONING"
fi

DISPLAY=":0.0"
XAUTHORITY=$HOME/.Xauthority
export DISPLAY XAUTHORITY HOME
i="10"
while [ $i -gt 0 ]
do
    let i-=1
    usbkbd_id=`xinput -list | grep "USB .*Keyboard" | awk -F'=' '{print $2}' | cut -c 1-2 | head -1`
    if [ "${usbkbd_id}" ]; then
        #gsettings set org.gnome.settings-daemon.plugins.keyboard active false
        setxkbmap -device "${usbkbd_id}" -layout us -variant dvp -option caps:escape
    fi
    sleep 0.3
done


# you can see your current layout by running
# setxkbmap -print -verbose 10
#Trying to load rules file /usr/share/X11/xkb/rules/evdev...
#Success.
#Applied rules from evdev:
#rules:      evdev
#model:      pc104
#layout:     us
#Trying to build keymap using the following components:
#keycodes:   evdev+aliases(qwerty)
#types:      complete
#compat:     complete
#symbols:    pc+us+inet(evdev)
#geometry:   pc(pc104)
#xkb_keymap {
#        xkb_keycodes  { include "evdev+aliases(qwerty)" };
#        xkb_types     { include "complete"      };
#        xkb_compat    { include "complete"      };
#        xkb_symbols   { include "pc+us+inet(evdev)"     };
#        xkb_geometry  { include "pc(pc104)"     };
#};
