hugo_dir="$HOME/Data/blog"
editor=$(which code || which zed || echo 'code')
blog() {
    $editor "$hugo_dir"
}

blognew() (
    cd $hugo_dir # https://unix.stackexchange.com/questions/612611/can-i-make-cd-be-local-to-a-function
    post_dir="content/posts/$1"

    if [ ! -d "$post_dir" ]; then
        mkdir -p "$post_dir"
    fi

    hugo new "$post_dir/index.md"
    $editor "$post_dir/index.md"
)

blogdate() {
    TZ=Asia/Ho_Chi_Minh date +"%Y-%m-%dT%H:%M:%S+07:00" | tr -d '\n' | tee >(pbcopy)
    echo "\nCopied to clipboard."
}