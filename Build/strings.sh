#!/bin/sh

set -e

function realpath() {
	[[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

ROOT_DIRECTORY=$(realpath "${BASH_SOURCE[0]}")
ROOT_DIRECTORY=`dirname "$ROOT_DIRECTORY"`/..

IMP_DIRECTORY=$ROOT_DIRECTORY/Build/Imp

if [ "$1" != "--quick" ]; then
	if [ -d "$IMP_DIRECTORY" ]; then
		cd "$IMP_DIRECTORY"
		git pull
	else
		git clone https://github.com/fluidsonic/imp.git "$IMP_DIRECTORY"
		cd "$IMP_DIRECTORY"
	fi

	git submodule update --init --recursive
	pod update
	xcodebuild -configuration Debug -scheme RunnerBundle -workspace Runner.xcworkspace/ install "DSTROOT=$IMP_DIRECTORY/Build" # Release builds crash :(
fi

IMP=$IMP_DIRECTORY/Build/Library/Bundles/imp-cli.bundle/Contents/MacOS/imp-cli

cd "$ROOT_DIRECTORY"
"$IMP" strings --destination "Sources/Measures/Resources/MeasuresStrings.swift" --no-emit-jetpack-import --tableName MeasuresLocalizable --typeName MeasuresStrings --visibility internal "Sources/Measures/Resources/en.lproj/MeasuresLocalizable.strings"
