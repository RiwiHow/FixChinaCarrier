##########################################################################################
#
# MMT Extended Utility Functions
#
##########################################################################################


abort() {
  ui_print "$1"
  rm -rf $MODPATH 2>/dev/null
  cleanup
  rm -rf $TMPDIR 2>/dev/null
  exit 1
}

# Spaces
sp() {
	ui_print " "
	ui_print " "
}

apn_place_choose() {
	run_addons
	sp
	ui_print "Please use the volume keys to select"
	ui_print "请用音量键进行选择"
	ui_print "eg."
	ui_print "示例:"
	ui_print "Vol+ = true"
	ui_print "音量+ = 是"
	ui_print "Vol- = false"
	ui_print "音量- = 否"
	sp
	ui_print "Do you want to replace apns_conf.xml in all directories? (This may cause some unknown issues)"
	ui_print "您是否想替换所有目录的 apns_conf.xml？（这可能会造成某些未知的问题）"
	ui_print "Vol+ = true"
	ui_print "音量+ = 是"
	ui_print "Vol- = false"
	ui_print "音量- = 否"
	if $VKSEL; then
		REPLACEALL=true
		return 0
	else
		REPLACEALL=false
	fi
	sp
	ui_print "Please select the directory you want to replace"
	ui_print "请选择您想要替换的目录"
	bak=$IFS
	IFS=$'\n'
	for i in $(echo "$q");
	do
		sp
		ui_print "Vol+ = $i"
		ui_print "音量+ = $i"
		ui_print "Vol- = Other directory"
		ui_print "音量- = 其他目录"
		if $VKSEL; then
			APNCONFDIR="$MODPATH/${i%/*}"
			continue
		else
		    sp
			ui_print "Please continue your selection"
			ui_print "请继续您的选择"
		fi
	done
	IFS=$bak
	if [ -z $APNCONFDIR ]; then
	sp
	ui_print "The module has an internal error, the installation failed"
	ui_print "模块出现内部错误, 安装失败"
	ui_print "We hope to collect some information to help us. To confirm the problem, the collected information will be output to /sdcard/apnconfdir-debug.log. You can choose whether to send the log to the developer after reading the log file."
	ui_print "我们希望收集一些信息以帮助我们确认这个问题，收集的信息将会输出到 /sdcard/apnconfdir-debug.log。您可以在阅读 log 后选择是否发送 log 给开发者。"
	debug_log apnconfdir
	abort
	fi
}

run_addons() {
	if [ "$(ls -A $MODPATH/common/addon/*/install.sh 2>/dev/null)" ]; then
		ui_print " "; ui_print "- Running Addons -"
		for i in $MODPATH/common/addon/*/install.sh; do
			ui_print "  Running $(echo $i | sed -r "s|$MODPATH/common/addon/(.*)/install.sh|\1|")..."
			. $i
		done
	fi
}

cleanup() {
  $BOOTMODE || { umount_apex; recovery_cleanup; }
  rm -rf $MODPATH/common 2>/dev/null
  ui_print " "
  ui_print "    **************************************"
  ui_print "    *   MMT Extended by Zackptg5 @ XDA   *"
  ui_print "    **************************************"
  ui_print " "
  rm -rf $TMPDIR 2>/dev/null
}

debug_log() {
  LOGID=$1
  $BOOTMODE && local LOG=/storage/emulated/0/$LOGID-debug || local LOG=/data/media/0/$LOGID-debug
  echo "$LOGID" > $LOG-tmp.log
  echo -e "***---Device Info---***" > $LOG-tmp.log
  echo -e "\n---Props---\n" >> $LOG-tmp.log
  getprop >> $LOG-tmp.log
  echo -e "\n\n***---Magisk Info---***" >> $LOG-tmp.log
  echo -e "\n---Magisk Version---\n\n$MAGISK_VER_CODE" >> $LOG-tmp.log
  echo -e "\n---Installed Modules---\n" >> $LOG-tmp.log
  ls $NVBASE/modules >> $LOG-tmp.log
  echo -e "\n---Last Magisk Log---\n" >> $LOG-tmp.log
  [ -d /cache ] && cat /cache/magisk.log >> $LOG-tmp.log || cat /data/cache/magisk.log >> $LOG-tmp.log
  echo -e "\n\n***---MMT Extended Debug Info---***" >> $LOG-tmp.log
  echo -e "\n---Installed Files---\n" >> $LOG-tmp.log
  grep "^+* cp_ch" $LOG.log | sed 's/.* //g' >> $LOG-tmp.log
  sed -i -e "\|$TMPDIR/|d" -e "\|$MODPATH|d" $LOG-tmp.log
  find $MODPATH -type f > $LOG-tmp.log
  echo -e "\n---Installed Boot Scripts---\n" >> $LOG-tmp.log
  grep "^+* install_script" $LOG.log | sed -e 's/.* //g' -e 's/^-.* //g' >> $LOG-tmp.log
  echo -e "\n---Installed Prop Files---\n" >> $LOG-tmp.log
  grep "^+* prop_process" $LOG.log | sed 's/.* //g' >> $LOG-tmp.log
  echo -e "\n---Shell & MMT Extended Variables---\n" >> $LOG-tmp.log
  (set) >> $LOG-tmp.log
  echo -e "\n---(Un)Install Log---\n" >> $LOG-tmp.log
  echo "$(cat $LOG.log)" >> $LOG-tmp.log
  mv -f $LOG-tmp.log $LOG.log
}

device_check() {
  local opt=`getopt -o dm -- "$@"` type=device
  eval set -- "$opt"
  while true; do
    case "$1" in
      -d) local type=device; shift;;
      -m) local type=manufacturer; shift;;
      --) shift; break;;
      *) abort "Invalid device_check argument $1! Aborting!";;
    esac
  done
  local prop=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  for i in /system /vendor /odm /product; do
    if [ -f $i/build.prop ]; then
      for j in "ro.product.$type" "ro.build.$type" "ro.product.vendor.$type" "ro.vendor.product.$type"; do
        [ "$(sed -n "s/^$j=//p" $i/build.prop 2>/dev/null | head -n 1 | tr '[:upper:]' '[:lower:]')" == "$prop" ] && return 0
      done
    fi
  done
  return 1
}

cp_ch() {
  local opt=`getopt -o nr -- "$@"` BAK=true UBAK=true FOL=false
  eval set -- "$opt"
  while true; do
    case "$1" in
      -n) UBAK=false; shift;;
      -r) FOL=true; shift;;
      --) shift; break;;
      *) abort "Invalid cp_ch argument $1! Aborting!";;
    esac
  done
  local SRC="$1" DEST="$2" OFILES="$1"
  $FOL && local OFILES=$(find $SRC -type f 2>/dev/null)
  [ -z $3 ] && PERM=0644 || PERM=$3
  case "$DEST" in
    $TMPDIR/*|$MODULEROOT/*|$NVBASE/modules/$MODID/*) BAK=false;;
  esac
  for OFILE in ${OFILES}; do
    if $FOL; then
      if [ "$(basename $SRC)" == "$(basename $DEST)" ]; then
        local FILE=$(echo $OFILE | sed "s|$SRC|$DEST|")
      else
        local FILE=$(echo $OFILE | sed "s|$SRC|$DEST/$(basename $SRC)|")
      fi
    else
      [ -d "$DEST" ] && local FILE="$DEST/$(basename $SRC)" || local FILE="$DEST"
    fi
    if $BAK && $UBAK; then
      [ ! "$(grep "$FILE$" $INFO 2>/dev/null)" ] && echo "$FILE" >> $INFO
      [ -f "$FILE" -a ! -f "$FILE~" ] && { mv -f $FILE $FILE~; echo "$FILE~" >> $INFO; }
    elif $BAK; then
      [ ! "$(grep "$FILE$" $INFO 2>/dev/null)" ] && echo "$FILE" >> $INFO
    fi
    install -D -m $PERM "$OFILE" "$FILE"
  done
}

install_script() {
  case "$1" in
    -l) shift; local INPATH=$NVBASE/service.d;;
    -p) shift; local INPATH=$NVBASE/post-fs-data.d;;
    *) local INPATH=$NVBASE/service.d;;
  esac
  [ "$(grep "#!/system/bin/sh" $1)" ] || sed -i "1i #!/system/bin/sh" $1
  local i; for i in "MODPATH" "LIBDIR" "MODID" "INFO" "MODDIR"; do
    case $i in
      "MODPATH") sed -i "1a $i=$NVBASE/modules/$MODID" $1;;
      "MODDIR") sed -i "1a $i=\${0%/*}" $1;;
      *) sed -i "1a $i=$(eval echo \$$i)" $1;;
    esac
  done
  [ "$1" == "$MODPATH/uninstall.sh" ] && return 0
  case $(basename $1) in
    post-fs-data.sh|service.sh) ;;
    *) cp_ch -n $1 $INPATH/$(basename $1) 0755;;
  esac
}

prop_process() {
  sed -i -e "/^#/d" -e "/^ *$/d" $1
  [ -f $MODPATH/system.prop ] || mktouch $MODPATH/system.prop
  while read LINE; do
    echo "$LINE" >> $MODPATH/system.prop
  done < $1
}

# Check available
q=$(find /system -name "apns-conf.xml" -type f)

if [ -z "$q" ]; then
	ui_print "This operating ROM is not supported."
	ui_print "目标 ROM 不受支持！"
	ui_print "We hope to collect some information to help us. To confirm the problem, the collected information will be output to /sdcard/$MODID-debug.log. You can choose whether to send the log to the developer after reading the log file."
	ui_print "我们希望收集一些信息以帮助我们确认这个问题，收集的信息将会输出到 /sdcard/unsupportedrom-debug.log。您可以在阅读 log 后选择是否发送 log 给开发者。"
	debug_log unsupportedrom
	abort
fi

MIUI=$(grep_prop "ro.miui.ui.version.*")
MIUI_framework=$(pm list packages | grep com.xiaomi.xmsf)
if [ $MIUI ]; then
	if [ -z "$MIUI_framework" ]; then
		ui_print "Warning! you don’t seem to be using MIUI, but MIUI_Version is found in Props."
		ui_print "警告！您似乎并没有使用 MIUI，但是 Props 中出现了 MIUI 版本号。"
		ui_print "We hope to collect some information to help us. To confirm the problem, the collected information will be output to /sdcard/miui.log. You can choose whether to send the log to the developer after reading the log file."
		ui_print "我们希望收集一些信息以帮助我们确认这个问题，收集的信息将会输出到 /sdcard/miui-debug.log。您可以在阅读 log 后选择是否发送 log 给开发者。"
		debug_log miui
	else
		ui_print "MIUI Detected"
		ui_print "检测到 MIUI"
		ui_print "You don’t need to flash this module"
		ui_print "您不需要刷入这个模块"
		abort
	fi
fi


# Check for min/max api version
[ -z $MINAPI ] || { [ $API -lt $MINAPI ] && abort "! Your system API of $API is less than the minimum api of $MINAPI! Aborting!"; }
[ -z $MAXAPI ] || { [ $API -gt $MAXAPI ] && abort "! Your system API of $API is greater than the maximum api of $MAXAPI! Aborting!"; }

# Set variables
[ $API -lt 26 ] && DYNLIB=false
[ -z $DYNLIB ] && DYNLIB=false
[ -z $DEBUG ] && DEBUG=false
[ -e "$PERSISTDIR" ] && PERSISTMOD=$PERSISTDIR/magisk/$MODID
INFO=$NVBASE/modules/.$MODID-files
ORIGDIR="$MAGISKTMP/mirror"
if $DYNLIB; then
  LIBPATCH="\/vendor"
  LIBDIR=/system/vendor
else
  LIBPATCH="\/system"
  LIBDIR=/system
fi
if ! $BOOTMODE; then
  ui_print "- Only uninstall is supported in recovery"
  ui_print "  Uninstalling!"
  touch $MODPATH/remove
  [ -s $INFO ] && install_script $MODPATH/uninstall.sh || rm -f $INFO $MODPATH/uninstall.sh
  recovery_cleanup
  cleanup
  rm -rf $NVBASE/modules_update/$MODID $TMPDIR 2>/dev/null
  exit 0
fi

# Extract files
ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' 'common/functions.sh' -d $MODPATH >&2

# Remove files outside of module directory
ui_print "- Removing old files"

if [ -f $INFO ]; then
  while read LINE; do
    if [ "$(echo -n $LINE | tail -c 1)" == "~" ]; then
      continue
    elif [ -f "$LINE~" ]; then
      mv -f $LINE~ $LINE
    else
      rm -f $LINE
      while true; do
        LINE=$(dirname $LINE)
        [ "$(ls -A $LINE 2>/dev/null)" ] && break 1 || rm -rf $LINE
      done
    fi
  done < $INFO
  rm -f $INFO
fi

ui_print "APN configuration file found in the following directory"
ui_print "在以下目录发现 APN 配置文件"
echo "$q"

if [ $(echo "$q" | wc -l) -ge 2 ]; then
	ui_print "Warning! APN profile found in multiple locations"
	ui_print "警告！在多个目录发现 APN 配置文件！"
	apn_place_choose
else
	REPLACEALL=true
fi

### Install
ui_print "- Installing"

[ -f "$MODPATH/common/install.sh" ] && . $MODPATH/common/install.sh

ui_print "   Installing for $ARCH SDK $API device..."
# Remove comments from files and place them, add blank line to end if not already present
for i in $(find $MODPATH -type f -name "*.sh" -o -name "*.prop" -o -name "*.rule"); do
  [ -f $i ] && { sed -i -e "/^#/d" -e "/^ *$/d" $i; [ "$(tail -1 $i)" ] && echo "" >> $i; } || continue
  case $i in
    "$MODPATH/service.sh") install_script -l $i;;
    "$MODPATH/post-fs-data.sh") install_script -p $i;;
    "$MODPATH/uninstall.sh") if [ -s $INFO ] || [ "$(head -n1 $MODPATH/uninstall.sh)" != "# Don't modify anything after this" ]; then
                               install_script $MODPATH/uninstall.sh
                             else
                               rm -f $INFO $MODPATH/uninstall.sh
                             fi;;
  esac
done

$IS64BIT || for i in $(find $MODPATH/system -type d -name "lib64"); do rm -rf $i 2>/dev/null; done  
[ -d "/system/priv-app" ] || mv -f $MODPATH/system/priv-app $MODPATH/system/app 2>/dev/null
[ -d "/system/xbin" ] || mv -f $MODPATH/system/xbin $MODPATH/system/bin 2>/dev/null
if $DYNLIB; then
  for FILE in $(find $MODPATH/system/lib* -type f 2>/dev/null | sed "s|$MODPATH/system/||"); do
    [ -s $MODPATH/system/$FILE ] || continue
    case $FILE in
      lib*/modules/*) continue;;
    esac
    mkdir -p $(dirname $MODPATH/system/vendor/$FILE)
    mv -f $MODPATH/system/$FILE $MODPATH/system/vendor/$FILE
    [ "$(ls -A `dirname $MODPATH/system/$FILE`)" ] || rm -rf `dirname $MODPATH/system/$FILE`
  done
  # Delete empty lib folders (busybox find doesn't have this capability)
  toybox find $MODPATH/system/lib* -type d -empty -delete >/dev/null 2>&1
fi

# Set permissions
ui_print " "
ui_print "- Setting Permissions"
set_perm_recursive $MODPATH 0 0 0755 0644
if [ -d $MODPATH/system/vendor ]; then
  set_perm_recursive $MODPATH/system/vendor 0 0 0755 0644 u:object_r:vendor_file:s0
  [ -d $MODPATH/system/vendor/app ] && set_perm_recursive $MODPATH/system/vendor/app 0 0 0755 0644 u:object_r:vendor_app_file:s0
  [ -d $MODPATH/system/vendor/etc ] && set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0644 u:object_r:vendor_configs_file:s0
  [ -d $MODPATH/system/vendor/overlay ] && set_perm_recursive $MODPATH/system/vendor/overlay 0 0 0755 0644 u:object_r:vendor_overlay_file:s0
  for FILE in $(find $MODPATH/system/vendor -type f -name *".apk"); do
    [ -f $FILE ] && chcon u:object_r:vendor_app_file:s0 $FILE
  done
fi
set_permissions

# Complete install
cleanup
