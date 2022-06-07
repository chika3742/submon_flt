#!/bin/bash

echo $DOTENV_BASE64 > ../.env
echo $GOOGLE_SERVICE_INFO_PLIST_BASE64 > GoogleService-Info-release.plist

brew install cocoapods
git clone https://github.com/flutter/flutter.git
export PATH=$PATH:$(pwd)/flutter/bin

flutter pub get
flutter precache --ios

pod install

