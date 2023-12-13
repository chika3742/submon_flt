function takeScreenshotsAndroid() {
    ~/Library/Android/sdk/emulator/emulator @"$1" -netdelay none -netspeed full &
    adb wait-for-device
    takeScreenshots "$2"
    kill %%
    sleep 3
}

function takeScreenshotsApple() {
    xcrun simctl boot "$1"
    xcrun simctl bootstatus "$1"
    takeScreenshots "$2"
    xcrun simctl shutdown "$1"
}

function takeScreenshots() {
    flutter drive --driver test_driver/integration_test.dart --target integration_test/screenshot_test.dart --dart-define SCREENSHOT_MODE=true --dart-define SCREENSHOT_NAME="$1"
}

# iPhone 8 Plus
#takeScreenshotsApple 49AAD78E-CE3A-44FD-821D-4F9088714A3A screenshots/apple/5.5-inch

# iPhone 15 Pro Max
#takeScreenshotsApple FA20246C-B502-4A25-9110-19EA7E4BBD53 screenshots/apple/6.7-inch

# iPad Pro (12.9-inch) (2nd generation)
#takeScreenshotsApple E6927B18-93E3-423D-9112-0C1ED052FBDD screenshots/apple/12.9-inch-gen2

# iPad Pro (12.9-inch) (6th generation)
#takeScreenshotsApple 687AA52C-A548-4B4D-90A8-F02916EDCBF7 screenshots/apple/12.9-inch-gen6

#takeScreenshotsAndroid Pixel_6_API_33 screenshots/android/5.7-inch

takeScreenshotsAndroid 7-inch_Tablet_API_33 screenshots/android/7-inch

takeScreenshotsAndroid 10-inch_Tablet_API_33 screenshots/android/10-inch

echo "Completed!"
