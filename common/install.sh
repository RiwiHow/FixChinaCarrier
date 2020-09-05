if [ $REPLACEALL = "true" ]; then
	for i in `find /system -name "apns-conf.xml" -type f`;
	do
		APNCONFDIR="$MODPATH/${i%/*}"
		if [[ ! -d "$APNCONFDIR" ]]; then
			mkdir -p "$APNCONFDIR"
			cp $MODPATH/APN/apns-conf.xml $APNCONFDIR
		fi
	done
	rm -f $MODPATH/APN/apns-conf.xml
fi

if [ ! -z $APNCONFDIR ]; then
	mkdir -p $APNCONFDIR
	cp $MODPATH/APN/apns-conf.xml $APNCONFDIR
	rm -f $MODPATH/APN/apns-conf.xml
fi

# Remove stuffs that don't belong to modules
rm -rf \
$MODPATH/system/placeholder $MODPATH/Doc $MODPATH/APN $MODPATH/customize.sh \
$MODPATH/README.md $MODPATH/LICENSE $MODPATH/.git* 2>/dev/null
