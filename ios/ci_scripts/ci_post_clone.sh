#!/bin/bash

echo $DOTENV_BASE64 | base64 -d > ../../.env
echo $GOOGLE_SERVICE_INFO_PLIST_BASE64 | base64 -d > ../GoogleService-Info-release.plist
ls

brew install cocoapods
git clone https://github.com/flutter/flutter.git
export PATH=$PATH:$(pwd)/flutter/bin

flutter pub get
flutter precache --ios

pod install

