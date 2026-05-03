reloaddns() {
	ssh pihole 'pihole reloaddns'
	sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}

