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
	abort "- Unsupported system!"
fi

ui_print "- It seems that your APN conf is at $APNCONFDIR"
ui_print "- If there is some wrong, please report"
unzip -qjo "$ZIPFILE" 'APN/*' -d $MODPATH >&2
mkdir -p $MODPATH$APNCONFDIR
cp $MODPATH/apns-conf.xml $MODPATH$APNCONFDIR

# Delete unnecessary files
rm -rf \
$MODPATH/system/placeholder $MODPATH/customize.sh \
$MODPATH/*.md $MODPATH/.git* $MODPATH/LICENSE 2>/dev/null

# Set 
  set_perm_recursive $MODPATH 0 0 0755 0644

