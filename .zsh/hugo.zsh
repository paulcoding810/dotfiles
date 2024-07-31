blog() {
	code /Volumes/DATA/hugo/fixthebug
}

blognew() {
	cd /Volumes/DATA/hugo/fixthebug
	# path="content/posts/$1/index.md"
	hugo new content content/posts/$1/index.md
	code content/posts/$1/index.md
}
