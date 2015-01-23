#!/bin/bash
set -e
set -o pipefail

# Check for xcpretty
hash xcpretty 2>/dev/null || { gem install xcpretty; }

clean() {
	xcodebuild \
	  -project MusicKit.xcodeproj \
	  -alltargets \
	  clean | xcpretty -cs
}

build() {
	xcodebuild \
	  -project MusicKit.xcodeproj \
	  -scheme MusicKit | xcpretty -cs

	xcodebuild \
	  -project MusicKit.xcodeproj \
	  -scheme MusicKitOSX | xcpretty -cs

	xcodebuild \
	  -workspace MusicKit.xcworkspace \
	  -scheme PreviewGenerator | xcpretty -cs
}

test() {
	# Always build the PreviewGenerator to verify CI
	xcodebuild \
	  -workspace MusicKit.xcworkspace \
	  -scheme PreviewGenerator \
	  -destination 'platform=OS X,arch=x86_64' | xcpretty -cs

	xcodebuild \
	  -project MusicKit.xcodeproj \
	  -scheme MusicKitOSX \
	  -destination 'platform=OS X,arch=x86_64' \
	  test | xcpretty -cs

	xcodebuild \
	  -project MusicKit.xcodeproj \
	  -scheme MusicKit \
	  -destination 'platform=iOS Simulator,name=iPad Air,OS=latest' \
	  -destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=latest' \
	  -destination 'platform=iOS Simulator,name=iPad 2,OS=7.1' \
	  test | xcpretty -cs
}

case $1 in
	clean)
		clean
		;;
	build)
		build
		;;
	test)
		test
		;;
	*)
		test
		;;
esac
