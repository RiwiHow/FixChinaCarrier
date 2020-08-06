SKIPUNZIP=0
REPLACE="
"

ui_print "- Unziping module"

if [ -f "/etc/apns-conf.xml" ]; then
	APNCONFDIR="/etc"
elif [ -f "/vendor/etc/apns-conf.xml" ]; then
	APNCONFDIR="/system/vendor/etc"
elif [ -f "/product/etc/apns-conf.xml" ]; then
	APNCONFDIR="/system/product/etc"
else
	abort "Unsupported system!"
fi

ui_print "It seems that your APN conf is at $APNCONFDIR"
ui_print "If there is some wrong, please report"
[[ ! -f "$MODPATH/apns-conf.xml" ]] && unzip -qjo "$ZIPFILE" 'APN/*' -d $MODPATH >&2
mkdir -p $MODPATH$APNCONFDIR
[[ -f "$MODPATH/APN/apns-conf.xml" ]] && mv -f $MODPATH/APN/apns-conf.xml $MODPATH/apns-conf.xml
mv -f $MODPATH/apns-conf.xml $MODPATH$APNCONFDIR
[[ -f "$MODPATH$APNCONFDIR/apns-conf.xml" ]] && rm -rf $MODPATH/APN
# Set 
  set_perm_recursive $MODPATH 0 0 0755 0644

