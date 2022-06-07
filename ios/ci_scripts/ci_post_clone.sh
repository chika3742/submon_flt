#!/bin/bash

brew install cocoapods
git clone https://github.com/flutter/flutter.git
export PATH=$PATH:$(pwd)/flutter/bin

flutter pub get

pod install
