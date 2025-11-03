# iOS Permissions Troubleshooting Guide

## ✅ Permissions Already Configured

The following permissions are properly configured in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to the camera to take photos.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to the photo library to select and save photos.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs access to save photos to your photo library.</string>
```

## 🔧 Steps to Fix Permission Issues on iOS

### 1. Clean Build
```bash
flutter clean
cd ios
pod install
cd ..
flutter pub get
```

### 2. Delete App from Device/Simulator
- **Important:** Permissions are cached by iOS. You MUST delete the app completely from your device/simulator before testing again.
- Long-press the app icon > Remove App > Delete App

### 3. Rebuild and Run
```bash
flutter run
```

### 4. Check iOS Settings (if permissions still not working)
If you previously denied permissions:
- Go to Settings > Privacy & Security > Camera (or Photos)
- Find "Photo Gallery" app and enable it
- Restart the app

## 🔍 Common Issues & Solutions

### Issue 1: Permission Dialog Never Appears
**Solution:** 
- Delete the app from device/simulator
- Clean and rebuild the project
- Make sure Info.plist has the usage descriptions

### Issue 2: "Permission Denied" Even After Allowing
**Solution:**
- Check that you're running on a real device (simulator has limitations)
- Verify the Info.plist keys are exactly as shown above
- Delete app and reinstall

### Issue 3: Camera Works but Gallery Doesn't (or vice versa)
**Solution:**
- Each permission is requested separately
- Check Settings > Privacy to see which permissions are granted
- The app will show a dialog to open Settings if permission is permanently denied

### Issue 4: Image Picker Crashes on iOS
**Solution:**
- Make sure you ran `pod install` in the ios folder
- Verify minimum iOS version is set (should be iOS 12.0 or higher)
- Check that all pods are installed correctly

## 📱 Testing on iOS

### Simulator Limitations
- Camera is not available on iOS Simulator
- You can only test gallery picking on simulator
- Use a real device to test camera functionality

### Real Device Testing
1. Connect your iOS device
2. Trust the computer on your device
3. Run: `flutter run`
4. First time: Allow developer mode in Settings > Privacy & Security > Developer Mode

## 🛠️ Code Changes Made

The permission handling code now:
1. **Checks current permission status** before requesting
2. **Handles permanently denied permissions** with a dialog to open Settings
3. **Properly handles iOS limited photo access** (returns true for isLimited)
4. **Platform-specific permission handling** for iOS vs Android

## 📋 Verification Checklist

- [x] Info.plist contains all three usage descriptions
- [x] Pods are installed (image_picker_ios, permission_handler_apple)
- [x] Code checks permission status before requesting
- [x] Code handles permanently denied permissions
- [x] App deleted and reinstalled for testing
- [ ] Tested on real iOS device (camera)
- [ ] Tested photo library access
- [ ] Verified permission dialogs appear

## 🚀 Quick Test Commands

```bash
# Clean everything
flutter clean
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..

# Run on iOS simulator
flutter run -d "iPhone 15 Pro"

# Run on connected iOS device
flutter run -d <device-id>

# List available devices
flutter devices
```

## 💡 Tips

1. **Always delete the app** before testing permission changes
2. **Check iOS Settings** to see current permission state
3. **Use a real device** to test camera features
4. **Permissions are permanent** once denied - you must go to Settings to re-enable
5. The app now shows a dialog with "Open Settings" button if permissions are permanently denied

## ⚠️ Important Notes

- **iOS Simulator**: Camera not available, can only test gallery
- **iOS 14+**: Limited photo access is supported and treated as granted
- **First Launch**: Permission dialogs appear when you first try to use camera/gallery
- **Permission State**: iOS caches permission decisions per app bundle ID
