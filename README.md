# Photo Gallery App

A Flutter-based photo gallery application that integrates native device features for capturing and managing photos.

## Demo

A short demo video is available at `assets/demo.mp4`. To include and view it locally:

You can embed the video directly in Markdown (many renderers support raw HTML):

<video controls width="640">
   <source src="assets/demo.mp4" type="video/mp4">
   Your browser does not support the video tag. You can find the file at `assets/demo.mp4`.
</video>

## Features

- 📸 **Take Photos**: Capture photos directly using the device camera
- 🖼️ **Gallery Import**: Select and import photos from the device gallery
- 🗂️ **Grid View**: Display photos in a responsive grid layout (3 columns)
- 💾 **Local Storage**: Photos are saved persistently in local storage
- 🔍 **Full-Screen View**: Tap any photo to view it in full screen with pinch-to-zoom
- 🗑️ **Delete Photos**: Long-press on any photo to delete it
- 🔐 **Permission Handling**: Proper camera and photo library permission requests

## Technical Stack

### Dependencies
- `image_picker` (^1.1.2): For camera and gallery access
- `permission_handler` (^11.3.1): For handling device permissions
- `path_provider` (^2.1.4): For local storage management

### Architecture
- Material Design 3 UI
- Stateful widget management
- Hero animations for smooth transitions
- Interactive viewer for image zoom

## Platform Configuration

### Android
Permissions configured in `android/app/src/main/AndroidManifest.xml`:
- Camera access
- External storage (read/write)
- Media images (Android 13+)

### iOS
Usage descriptions configured in `ios/Runner/Info.plist`:
- Camera usage description
- Photo library usage description
- Photo library add usage description

## How to Use

1. **Add Photos**:
   - Tap the floating action button (+)
   - Choose "Take Photo" to use the camera
   - Or "Choose from Gallery" to import existing photos

2. **View Photos**:
   - Photos are displayed in a grid layout
   - Tap any photo to view it in full screen
   - Pinch to zoom in/out on full-screen images

3. **Delete Photos**:
   - Long-press on any photo in the grid
   - Confirm deletion in the dialog

## Running the App

```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Build for specific platform
flutter build apk      # Android
flutter build ios      # iOS
```

## Storage

Photos are stored in the application's documents directory under a `gallery` subfolder. This ensures photos persist between app sessions while being sandboxed to the application.

## Permissions

The app will request the following permissions at runtime:
- **Camera**: Required for taking photos
- **Photos/Storage**: Required for accessing and saving photos

If permissions are denied, the app will prompt users to enable them through the Settings app.

## Project Structure

```
lib/
  └── main.dart              # Main application code
android/                     # Android platform configuration
ios/                        # iOS platform configuration
```

## Future Enhancements

- Share photos to other apps
- Photo editing capabilities
- Albums/folders organization
- Cloud backup integration
- Search and filter functionality



Or provide a direct link in the README:

[Download / Play demo video](assets/demo.mp4)


