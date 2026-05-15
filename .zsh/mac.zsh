flushdns() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

lock() {
  pmset displaysleepnow
}

appid() {
  script="osascript -e 'id of app \"$1\"'"
  sh -c $script
}
