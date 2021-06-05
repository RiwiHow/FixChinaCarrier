_bak=$IFS
IFS=$'\n'

if [ "$REPLACEALL" = "true" ]; then
	for i in $q; do
		APNCONFDIR="$MODPATH""${i%/*}"
		if [[ ! -d "$APNCONFDIR" ]]; then
			mkdir -p "$APNCONFDIR"
			cp "$MODPATH"/APN/apns-conf.xml "$APNCONFDIR"
		fi
	done
elif [ -n "$APNCONFDIR" ]; then
	mkdir -p "$APNCONFDIR"
	cp "$MODPATH"/APN/apns-conf.xml "$APNCONFDIR"
fi

IFS=$_bak

if [ "$UNINSTALLCARRIERSETTINGS" = "true" ]; then
	mkdir -p "$MODPATH"/system/product/priv-app/CarrierSettings
	touch "$MODPATH"/system/product/priv-app/CarrierSettings/.replace
fi

# Remove stuffs that don't belong to modules
rm -rf \
	"$MODPATH"/system/placeholder "$MODPATH"/Doc "$MODPATH"/APN "$MODPATH"/customize.sh \
	"$MODPATH"/README.md "$MODPATH"/LICENSE "$MODPATH"/.git* 2>/dev/null
