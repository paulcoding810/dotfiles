hugo_dir="$HOME/Data/blog"

blog() {
    zed "$hugo_dir"
}

blognew() (
	cd $hugo_dir # https://unix.stackexchange.com/questions/612611/can-i-make-cd-be-local-to-a-function
    post_dir="content/posts/$1"
    
    if [ ! -d "$post_dir" ]; then
        mkdir -p "$post_dir"
    fi
    
    hugo new "$post_dir/index.md"
    zed "$post_dir/index.md"
)
