#!/bin/bash

brew install cocoapods
git clone https://github.com/flutter/flutter.git
export PATH=$PATH:$(pwd)/flutter/bin

flutter pub get
flutter precache --ios

pod install

echo $DOTENV_BASE64 > .env
echo $GOOGLE_SERVICE_INFO_PLIST_BASE64 > ios/GoogleService-Info-release.plist
