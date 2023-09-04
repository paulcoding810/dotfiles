NC='\033[0m'       # Text Reset
BLACK='\033[0;30m' # Black
RED='\033[0;31m'   # Red
GREEN='\033[0;32m' # Green
red() { printf "\033[31m${1}\033[0m\n"; }
green() { printf "\033[32m${1}\033[0m\n"; }
yellow() { printf "\033[33m${1}\033[0m\n"; }
orange() { printf "\033[38;5;208m${1}\033[0m\n"; }
blue() { printf "\033[38;5;27m${1}\033[0m\n"; }
purple() { printf "\033[35m${1}\033[0m\n\n"; }

adbx() {
	if [[ $# -lt 1 ]]; then
		red 'error: missing device ordinal number'
		echo Usage:
		green '\tadbx 1'
		adb devices | sed -n "$device p" | sed 's/[[:space:]]device//'
		return 1
	fi
	local adb_path=$(alias adb)
	[ -z $adb_path ] || unalias adb
	local device=$(expr $1 + 1)
	local ip=$(adb devices | sed -n "$device p" | sed 's/[[:space:]]device//')
	local model=$(adb -s $ip shell getprop ro.product.model)
	green "using $model ($ip)"
	alias adb="adb -s ${ip}"
	alias scrcpy="scrcpy -s ${ip} > /dev/null 2&>1 &"
	echo sourcing...
	source ~/.zsh/adb.zsh
}
adbw() {
	adb tcpip 5555
}
adbc() {
	adb shell settings get global http_proxy
	adb reverse tcp:8081 tcp:8081
	adb reverse tcp:9090 tcp:9090
	adb reverse tcp:8000 tcp:8000
	adb reverse tcp:8097 tcp:8097
	adb reverse tcp:3000 tcp:3000
	adb reverse tcp:8080 tcp:8080
	adb reverse --list
}
adbs() {
	adb shell screencap /data/local/tmp/screenshot.png
	adb pull /data/local/tmp/screenshot.png ~/Downloads
	impbcopy ~/Downloads/screenshot.png
}
adbr() {
	local destination_path=${1:-~/Downloads}
	adb shell screenrecord /data/local/tmp/screenrecord.mp4 &
	local recording_pid=$!
	echo "Screen recording started. Press Ctrl + C to stop..."
	trap '[[ -n "$recording_pid" ]] && ps -p "$recording_pid" > /dev/null && kill "$recording_pid"' INT
	wait $recording_pid
	sleep 1
	adb pull /data/local/tmp/screenrecord.mp4 "$destination_path/screenrecord.mp4"
	echo "Video file pulled to $destination_path/screenrecord.mp4"
}
