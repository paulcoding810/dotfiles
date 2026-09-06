# Export Paths
apps=(
	"$GEM_HOME/bin"
	"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
	"/Applications/TextMate.app/Contents/MacOS/"
	"/Applications/Firefox Developer Edition.app/Contents/MacOS"
	"/Applications/Android Studio.app/Contents/MacOS"
	"/Applications/Beyond Compare.app/Contents/MacOS"
	"/Applications/Sublime Text.app/Contents/SharedSupport/bin"
	"${HOME}/Library/flutter/bin"
	"${HOME}/Library/nvim-macos/bin"
	"${HOME}/Library/fresh-editor-aarch64-apple-darwin"
	"${HOME}/Library/pnpm"
	"${HOME}/.bin"
	"${HOME}/.local/bin"
	"${HOME}/.spicetify"
	"${HOME}/.nvm/versions/node/v22.17.0/bin"
	"${HOME}/.maestro/bin"
	"/opt/homebrew/bin"
	"/usr/local/bin/quickemu"
	"/usr/local/bin"
	"/usr/local/bin/vd-tool/bin"
	"$(python3 -m site --user-base)/bin"
)

for app in "${apps[@]}"; do
	export PATH="$app":$PATH
done
