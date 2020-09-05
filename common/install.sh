if [ $REPLACEALL = "true" ]; then
	for i in `find /system -name "apns-conf.xml" -type f`;
	do
		APNCONFDIR="$MODPATH/${i%/*}"
		if [[ ! -d "$APNCONFDIR" ]]; then
			mkdir -p "$APNCONFDIR"
			cp $MODPATH/APN/apns-conf.xml $APNCONFDIR
			rm -f $MODPATH/APN/apns-conf.xml
		fi
	done
fi

if [ ! -z $APNCONFDIR ]; then
	mkdir -p $APNCONFDIR
	cp $MODPATH/APN/apns-conf.xml $APNCONFDIR
	rm -f $MODPATH/APN/apns-conf.xml
fi
