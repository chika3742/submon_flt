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

takeScreenshotsAndroid Pixel_4_API_31 screenshots/android/5.7-inch

takeScreenshotsAndroid 7-inch_Tablet_API_32 screenshots/android/7-inch

takeScreenshotsAndroid 10-inch_Tablet_API_32 screenshots/android/10-inch

takeScreenshotsApple F9439CBB-BCF0-48A6-9013-B2D12451CCA0 screenshots/apple/5.5-inch

takeScreenshotsApple 6C90BC3A-18DB-4AFD-B5AB-97EAA2A07419 screenshots/apple/6.5-inch

takeScreenshotsApple 5B7D79DE-882B-49CB-8DC9-1F19ED29181B screenshots/apple/12.9-inch-gen2

takeScreenshotsApple 26CF19A9-845A-4DB0-A3B2-64A9F8952A09 screenshots/apple/12.9-inch-gen3

echo "Completed!"
