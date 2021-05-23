if [ "$REPLACEALL" = "true" ]; then
	for i in "$(echo "$q" | awk '{printf "%s",$1}'| sed 's/ //g')"; do
		APNCONFDIR="$MODPATH/$i"
		if [[ ! -d "$APNCONFDIR" ]]; then
			mkdir -p "$APNCONFDIR"
			cp "$MODPATH"/APN/apns-conf.xml "$APNCONFDIR"
		fi
	done
	rm -f "$MODPATH"/APN/apns-conf.xml
elif [ -n "$APNCONFDIR" ]; then
	mkdir -p "$APNCONFDIR"
	cp "$MODPATH"/APN/apns-conf.xml "$APNCONFDIR"
	rm -f "$MODPATH"/APN/apns-conf.xml
fi

if [ "$UNINSTALLCARRIERSETTINGS" = "true" ]; then
	mkdir -p "$MODPATH"/system/product/priv-app/CarrierSettings
	touch "$MODPATH"/system/product/priv-app/CarrierSettings/.replace
fi

# Remove stuffs that don't belong to modules
rm -rf \
	"$MODPATH"/system/placeholder "$MODPATH"/Doc "$MODPATH"/APN "$MODPATH"/customize.sh \
	"$MODPATH"/README.md "$MODPATH"/LICENSE "$MODPATH"/.git* 2>/dev/null
