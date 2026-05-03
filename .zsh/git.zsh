git-reinit() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Not a git repository."
        return 1
    fi

    echo "⚠️  This will DELETE all Git history and start fresh."
    read -q "?Continue? (y/N) " ans
    echo
    if [[ $ans = [yY] ]]; then
        git checkout --orphan temp
        git add -A
        git commit -m "init"
        git branch -D main 2>/dev/null || true
        git branch -m main
        echo "✅ Repository reinitialized successfully."
    else
        echo "❌ Aborted."
    fi
}
