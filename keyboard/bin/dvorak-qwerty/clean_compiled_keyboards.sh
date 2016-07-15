#/bin/bash
# xkb compiles keymaps under /var/lib/xkb. When changing some keymaps,
# it is necessary to remove the compiled keymaps so that xkb remakes them.
# It may be necessary to restart twice

# Check if script has superuser permissions
if [ "$(id -u)" -ne 0 ];
then
   echo "Script requires superuser permissions"
   exit 1
fi


echo "removing compiled xkb keymaps from /var/lib/xkb/"
rm -f /var/lib/xkb/*.xkm
echo "you must restart computer for the keymaps to be recompiled"
