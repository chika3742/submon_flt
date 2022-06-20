function takeScreenshotsAndroid() {
    ~/Library/Android/sdk/emulator/emulator @$1 -netdelay none -netspeed full &
    adb wait-for-device
    takeScreenshots $2
    kill %%
    sleep 3
}

function takeScreenshotsApple() {
    xcrun simctl boot $1
    xcrun simctl bootstatus $1
    takeScreenshots $2
    xcrun simctl shutdown $1
}

function takeScreenshots() {
    flutter drive --driver test_driver/integration_test.dart --target integration_test/screenshot_test.dart --dart-define SCREENSHOT_MODE=true --dart-define SCREENSHOT_NAME="$1"
}

takeScreenshotsAndroid Pixel_4_API_31 android/5.7-inch

takeScreenshotsAndroid 7-inch_Tablet_API_32 android/7-inch

takeScreenshotsAndroid 10-inch_Tablet_API_32 android/10-inch

takeScreenshotsApple 1093BC2A-ADB9-431A-B235-A069421F1E38 apple/5.5-inch

takeScreenshotsApple 89D51A1C-43C9-4922-8902-47A9D07F7B7C apple/6.5-inch

takeScreenshotsApple 5147861C-76EB-462F-90D3-5130CF226BBD apple/12.9-inch-gen2

takeScreenshotsApple 4AAE26EA-B530-4AD1-B544-594F68E7BAE2 apple/12.9-inch-gen3

echo "Completed!"
