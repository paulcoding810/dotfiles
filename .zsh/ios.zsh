function ioshelp() {
	echo xcbuild	find and build xcworkspace
	echo sims	list simulators id
	echo simo 	open simulator by id
}

function xcbuild() {
  # Find the first .xcworkspace file in the current directory
  local workspace=$(find . -name "*.xcworkspace" -print -quit)

  if [ -z "$workspace" ]; then
    echo "Error: No .xcworkspace file found in the current directory."
    return 1
  fi

  # Extract scheme name from the workspace file
  local scheme=$(xcodebuild -list -workspace "$workspace" -json | jq -r '.workspace.schemes[0]')

  if [ -z "$scheme" ]; then
    echo "Error: Unable to detect scheme from the workspace."
    return 1
  fi

  # Output the xcodebuild command
  echo "xcodebuild -workspace \"$workspace\" -configuration Debug -scheme \"$scheme\" -destination id=986E820A-0FCD-48E8-A392-2A06C88F41C9 | xcpretty"
}

function sims() {
  echo "Available iOS Simulators:"

  # Use xcrun to list available simulators
  xcrun simctl list devices | grep -E "iPhone|iPad"
}

function simo(){
	xcrun simctl boot $1
}
alias simcache='rm -r ~/Library/Developer/CoreSimulator/Caches'
