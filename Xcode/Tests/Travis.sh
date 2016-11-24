#!/bin/sh

set -o pipefail

if [ "$POD_LINT" == "yes" ]; then
	(set -x; pod lib lint --allow-warnings --quick --verbose)
else
	cd Xcode
	(set -x; pod deintegrate)
	(set -x; rm -rf Podfile.lock Project.xcworkspace )
	(set -x; pod update --no-repo-update)
	cd ..

	ACTION="test"
	if [ "$SDK" == "$IOS_DEVICE_SDK" ] || [ "$SCHEME" == "All" ]; then
		ACTION="build"
	fi

	COMMAND="xcodebuild $ACTION -workspace \"$WORKSPACE\" -scheme \"$SCHEME\" -sdk \"$SDK\" -configuration \"$CONFIGURATION\""
	if [ "$DESTINATION" ]; then
		COMMAND="$COMMAND -destination \"$DESTINATION\""
	else
		COMMAND="$COMMAND CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO"
	fi

	export NSUnbufferedIO=YES # https://github.com/supermarin/xcpretty/issues/192
	COMMAND="$COMMAND | xcpretty -f `xcpretty-travis-formatter`"

	eval "set -x; $COMMAND"
fi
