blog() {
	zed /Volumes/DATA/hugo/blog
}

blognew() {
	cd /Volumes/DATA/hugo/blog
	# path="content/posts/$1/index.md"
	hugo new content content/posts/$1/index.md
	zed content/posts/$1/index.md
}
