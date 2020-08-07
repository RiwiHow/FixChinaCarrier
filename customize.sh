SKIPUNZIP=0

MIUI=$(grep_prop "ro.miui.ui.version.*")
if [ $MIUI ]; then
	ui_print "- MIUI Detected"
	abort "- You don’t need to install this module"
fi

if [ -f "/system/etc/apns-conf.xml" ]; then
	APNCONFDIR="/system/etc"
elif [ -f "/vendor/etc/apns-conf.xml" ]; then
	APNCONFDIR="/system/vendor/etc"
elif [ -f "/product/etc/apns-conf.xml" ]; then
	APNCONFDIR="/system/product/etc"
else
	abort "- This rom is not supported, Please report to the developer."
fi

ui_print "- It seems that your APN conf is at $APNCONFDIR"
ui_print "- If there is something wrong, please report"
mkdir -p $MODPATH$APNCONFDIR
[[ -f "$MODPATH/APN/apns-conf.xml" ]] && mv -f $MODPATH/APN/apns-conf.xml $MODPATH/apns-conf.xml
[[ ! -f "$MODPATH/apns-conf.xml" ]] && unzip -qjo "$ZIPFILE" 'APN/*' -d $MODPATH >&2
mv -f $MODPATH/apns-conf.xml $MODPATH$APNCONFDIR
[[ -f "$MODPATH$APNCONFDIR/apns-conf.xml" ]] && rm -rf $MODPATH/APN

# Remove stuffs that don't belong to modules
rm -rf \
$MODPATH/system/placeholder $MODPATH/customize.sh \
$MODPATH/*.md $MODPATH/.git* $MODPATH/LICENSE $MODPATH/Doc 2>/dev/null

# Set 
  set_perm_recursive $MODPATH 0 0 0755 0644

