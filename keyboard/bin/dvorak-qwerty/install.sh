#! /bin/bash

NAME=xkb-backup.tar.gz
CONF=/usr/share/X11/xkb
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# Check if script has superuser permissions
if [ "$(id -u)" -ne 0 ];
then
   echo "Script requires superuser permissions"
   exit 1
fi

if [ -f $CONF/symbols/usdvq ]; then
    echo "Dvorak-Qwerty already installed"
    exit 1
fi

# install new layout variants in rules section, so that it can be loaded
# with setxkbmap. This is handled by ./rules/install_rules.py
./rules/install_rules.py
# exit if python script had problems
if [ $? -eq 1 ]; then
    echo $?
    echo "Python script had errors. Aborting."
    echo "P.S. If it's unicode stuff, verify you are running python3!"
    exit 1
fi

echo "Backing up current configuration in $CONF/$NAME"
tar zcf $CONF/../$NAME $CONF --absolute-names
# tar would fail if it tried to zip up directory in which it also created a zip
mv $CONF/../$NAME $CONF/$NAME
DIRECTORY_OWNER=$(namei -o $PWD | tail -n 1 | awk '{if ($2) print $2}')
chown $DIRECTORY_OWNER -R $CONF/$NAME

echo "Copying Dvorak-Qwerty to types"
# install many dvorak-qwerty variants in the "us" symbols
# append to end of file
# this is OLD, the newer symbols file is separate
#if [[ ! `cat $CONF/symbols/us | grep "dvorak-qwerty"` ]]; then
#    echo "adding dvorak variants to US layout"
#    cat $SCRIPT_DIR/symbols/us >> $CONF/symbols/us
#fi

# if you ever change these files, you'll need to remove xkb's compiled cache of
# keymappings: sudo rm -f /var/lib/xkb/*.xkm
# link symbol file to xkb symbols
symbol_file="$SCRIPT_DIR/symbols/usdvq"
system_file="/usr/share/X11/xkb/symbols/usdvq"
ln -s $symbol_file $system_file

# link dvoraq-qwerty type to xkb types
# this is the part that makes redirection possible
symbol_file="$SCRIPT_DIR/types/dvorak-qwerty"
system_file="/usr/share/X11/xkb/types/dvorak-qwerty"
ln -s $symbol_file $system_file

# update "complete" types list so that dvorak-qwerty is accessible
# Aka adds '    include "dvorak-qwerty"'
# to ~end of $CONF/types/complete file so it'll look something like:

# default xkb_types "complete" {
#    include "basic"
#    include "mousekeys"
#    include "pc"
#    include "iso9995"
#    include "level5"
#    include "extra"
#    include "numpad"
#    include "dvorak-qwerty"
#};
if [[ ! `cat $CONF/types/complete | grep "dvorak-qwerty"` ]]; then
    echo "setting up 'dvorak-qwerty' in list of keyboard types"
    sed -i '/};/i \ \ \ \ include "dvorak-qwerty"' $CONF/types/complete
fi

exit 0
