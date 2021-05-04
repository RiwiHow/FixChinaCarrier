

function logcat_process() {
    LOGID=$1
    $BOOTMODE && local LOG=/storage/emulated/0/$LOGID-debug || local LOG=/data/media/0/$LOGID-debug
    echo "$LOGID" >$LOG-tmp.log
    echo -e "***---Device Info---***" >>$LOG-tmp.log
    echo -e "\n---Props---\n" >>$LOG-tmp.log
    getprop >>$LOG-tmp.log
    echo -e "\n\n***---Magisk Info---***" >>$LOG-tmp.log
    echo -e "\n---Magisk Version---\n\n$MAGISK_VER_CODE" >>$LOG-tmp.log
    echo -e "\n---Installed Modules---\n" >>$LOG-tmp.log
    ls $NVBASE/modules >>$LOG-tmp.log
    echo -e "\n---Last Magisk Log---\n" >>$LOG-tmp.log
    [ -d /cache ] && cat /cache/magisk.log >>$LOG-tmp.log || cat /data/cache/magisk.log >>$LOG-tmp.log
    echo -e "\n\n***---MMT Extended Debug Info---***" >>$LOG-tmp.log
    echo -e "\n---Installed Files---\n" >>$LOG-tmp.log
    grep "^+* cp_ch" $LOG.log | sed 's/.* //g' >>$LOG-tmp.log
    sed -i -e "\|$TMPDIR/|d" -e "\|$MODPATH|d" $LOG-tmp.log
    find $MODPATH -type f >>$LOG-tmp.log
    echo -e "\n---Installed Boot Scripts---\n" >>$LOG-tmp.log
    grep "^+* install_script" $LOG.log | sed -e 's/.* //g' -e 's/^-.* //g' >>$LOG-tmp.log
    echo -e "\n---Installed Prop Files---\n" >>$LOG-tmp.log
    grep "^+* prop_process" $LOG.log | sed 's/.* //g' >>$LOG-tmp.log
    echo -e "\n---Shell & MMT Extended Variables---\n" >>$LOG-tmp.log
    (set) >>$LOG-tmp.log
    echo -e "\n---(Un)Install Log---\n" >>$LOG-tmp.log
    echo "$(cat $LOG.log)" >>$LOG-tmp.log
    mv -f $LOG-tmp.log $LOG.log
}

logcat_process