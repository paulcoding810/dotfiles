# Add Android SDK tools
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"

if [ -d "${ANDROID_HOME}" ]; then
	PATH="${PATH}:${ANDROID_HOME}/platform-tools"
	PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
	ANDROID_BUILD_TOOLS_DIR="${ANDROID_HOME}/build-tools"

	NDK_DIR="${ANDROID_HOME}/ndk"
	if [ -d "${NDK_DIR}" ]; then
		PATH="${PATH}:${NDK_DIR}/$(ls -1 ${NDK_DIR} | sort -rn | head -1)/toolchains/llvm/prebuilt/darwin-x86_64/bin"
	fi

	PATH="${PATH}:${ANDROID_BUILD_TOOLS_DIR}/$(ls -1 ${ANDROID_BUILD_TOOLS_DIR} | sort -rn | head -1)"
	PATH="${PATH}:${ANDROID_HOME}/tools"
fi

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
	adb reverse tcp:8082 tcp:8082
	adb reverse tcp:8083 tcp:8083
	adb reverse tcp:9090 tcp:9090
	adb reverse tcp:8000 tcp:8000
	adb reverse tcp:8097 tcp:8097
	adb reverse tcp:3000 tcp:3000
	adb reverse tcp:8080 tcp:8080
	adb reverse tcp:1883 tcp:1883
	adb reverse --list
}
adbs() {
	name="${1:-screenshot}.png"
	adb shell screencap /data/local/tmp/screenshot.png
	adb pull /data/local/tmp/screenshot.png ~/Downloads/$name
	impbcopy "~/Downloads/$name"
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

## install apks from input
adbi() {
	adb install-multi-package $@
}
adbi-sync() {
	for f in $@; do
		echo installing $f
		adb install $f
		echo
	done
}

# list devices
adbd() {
	adb devices
}

# input text
adbt() {
	local text="$1"
	local quoted_text=$(echo "$text" | sed 's/;/\\;/g')
	adb shell input text "$quoted_text"
}

compress_video() {
	if [ "$#" -ne 1 ]; then
		echo "Usage: compress_video input_file "
		return 1
	fi

	input_file="$1"
	output_file="$HOME/Downloads/compressed.mp4"

	# Set CRF value based on desired compression level (adjust as needed)
	crf_value=23

	# Run ffmpeg command for video compression
	ffmpeg -i "$input_file" -c:v libx264 -crf "$crf_value" -c:a aac -strict experimental -b:a 192k "$output_file"

	if [ $? -eq 0 ]; then
		echo "Compression successful!"
		rm "$input_file"
	else
		echo "Compression failed!"
	fi
}

adbpush() {
	adb push $1 /storage/emulated/0/Download
}

# Function to turn on Android proxy, run mitmweb, and turn off proxy when mitmweb is killed
mitm() {
	echo ip=$(ip)

	adb shell settings put global http_proxy $(ip):8888

	mitmweb -p 8888 &

	# Get the process ID of mitmweb
	local mitmweb_pid=$!

	turn_off_proxy() {
		kill $mitmweb_pid
		trap - INT
		adb shell settings put global http_proxy :0
		echo "Proxy turned off"
	}

	trap turn_off_proxy INT

	wait ${mitmweb_pid}

	turn_off_proxy
}

apk_sha() {
	local file="$1"

	# Check if the file exists
	if [[ ! -f "$file" ]]; then
		echo "File does not exist."
		return 1
	fi

	# Check if the file is an XAPK (usually a ZIP file containing APKs)
	if [[ "$file" =~ \.(xapk|zip)$ ]]; then
		echo "Detected XAPK file."
		# Extract APK from XAPK (assuming it is a ZIP archive)
		local temp_dir=$(mktemp -d)
		unzip -q "$file" -d "$temp_dir"

		# Find the APK file inside the XAPK archive (assuming it's inside a folder named 'com' or similar)
		local apk_file
		apk_file=$(find "$temp_dir" -name "*.apk" -print -quit)

		if [[ -z "$apk_file" ]]; then
			echo "No APK found inside the XAPK file."
			rm -rf "$temp_dir"
			return 1
		fi

		echo "Found APK: $apk_file"
		file="$apk_file" # Set the file to the extracted APK
	fi

	# Now, we can calculate the SHA1 of the APK using keytool
	if command -v keytool &>/dev/null; then
		echo "Calculating SHA1..."
		keytool -printcert -jarfile "$file" | grep "SHA1" | awk '{print $2}'
	else
		echo "keytool command not found. Please install Java Development Kit (JDK)."
		return 1
	fi

	# Cleanup if the file was extracted from XAPK
	if [[ "$file" != "$1" ]]; then
		rm -rf "$temp_dir"
	fi
}

apk_dump() {
	if [ -z "$1" ]; then
		echo "Usage: dump_apk_by_name <name>"
		return 1
	fi

	SEARCH_NAME=$1
	PACKAGE_NAME=$(adb shell pm list packages | grep -i "$SEARCH_NAME" | sed 's/package://')

	if [ -z "$PACKAGE_NAME" ]; then
		echo "No package found matching '$SEARCH_NAME'."
		return 1
	fi

	echo "Found package: $PACKAGE_NAME"
	APK_PATH=$(adb shell pm path "$PACKAGE_NAME" 2>/dev/null)

	if [ -z "$APK_PATH" ]; then
		echo "Failed to find APK path for package '$PACKAGE_NAME'."
		return 1
	fi

	APK_PATH=${APK_PATH/package:/}

	echo "APK path for '$PACKAGE_NAME' is $APK_PATH"
	adb pull "$APK_PATH" .

	if [ $? -eq 0 ]; then
		echo "APK file has been dumped successfully."
	else
		echo "Failed to dump the APK file."
		return 1
	fi
}
logcat() {
	if [ -z "$1" ]; then
		echo "Usage: filter_logcat <process_name>"
		return 1
	fi

	local process_name="$1"
	local pid=$(adb shell ps -A | awk -v name="$process_name" '$0 ~ name {print $2}')

	if [[ -n "$pid" ]]; then
		echo "Filtering logcat for process: $process_name (PID: $pid)"
		adb logcat | grep "$pid"
	else
		echo "Process not found: $process_name"
	fi
}
