#! /bin/bash
# this script is run when the keyboard is plugged in, and it switches the
# keyboard layout to dvorak. This script is called by a script that executes in
# /etc/udev/rules.d
# You can see the rules.d script as a commented-out block at end of this file

# scripts called by /etc/udev/rules.d/* MUST call an intermediate script that
# backgrounds the actual task. This script recursively backgrounds itself in
# order to avoid being shut down by a udev/rules.d watchdog
if [[ $# == 0 ]]
then
    # re-run program in background using "at now"
    # you'll want to verify you have "at" installed
    # argument "x" is passed, which skips this section in the next run
    echo $0 "x" | at now
    # exit so that this process does not continue running
    exit
fi

# exporting of display somehow makes this work.
DISPLAY=":0.0"
export DISPLAY

# MULTIPLE TIMES set keyboard to dvorak. (because it resets ~.2 seconds in)
i="10"
while [ $i -gt 0 ]
do
    let i-=1
    # find ID of usb keyboard
    usbkbd_id=`xinput -list | grep "USB .*Keyboard" | awk -F'=' '{print $2}' | cut -c 1-2 | head -1`
    if [ "${usbkbd_id}" ]; then
        # set keyboard layout here. I also change capslock to escape
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



# BELOW HERE IS THE /etc/udev/rules.d script that runs this script
# http://ubuntuforums.org/archive/index.php/t-502864.html
# you can find the idVendor / Product by running dmesg | tail OR lsusb
ACTION=="add", \
SUBSYSTEM=="usb", \
ATTRS{idVendor}=="0510", \
ATTRS{idProduct}=="0032", \
# switch out of root access into <user>, such as lancey
RUN+="/usr/bin/sudo -u lancey /home/lancey/bin/switch_to_dvorak.sh", \
# to be extra sure, enable ALL users to access device
MODE="0666"
