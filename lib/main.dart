import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PhotoGalleryScreen(),
    );
  }
}

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({super.key});

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _imagePaths = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  // Load previously saved images from local storage
  Future<void> _loadSavedImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final galleryDir = Directory('${directory.path}/gallery');

      if (await galleryDir.exists()) {
        final files = galleryDir.listSync();
        setState(() {
          _imagePaths.clear();
          _imagePaths.addAll(
            files
                .where(
                  (file) =>
                      file.path.endsWith('.jpg') || file.path.endsWith('.png'),
                )
                .map((file) => file.path)
                .toList(),
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading saved images: $e');
    }
  }

  // Save image to local storage
  Future<String> _saveImageToLocalStorage(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final galleryDir = Directory('${directory.path}/gallery');

      if (!await galleryDir.exists()) {
        await galleryDir.create(recursive: true);
      }

      final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${galleryDir.path}/$fileName');
      await File(imagePath).copy(savedImage.path);

      return savedImage.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  // Take a photo with the camera
  Future<void> _takePhoto() async {
    setState(() => _isLoading = true);

    try {
      // On iOS, image_picker handles permissions internally
      // Just try to pick and it will show the system permission dialog
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        final savedPath = await _saveImageToLocalStorage(photo.path);
        setState(() {
          _imagePaths.insert(0, savedPath);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo saved successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Pick an image from gallery
  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);

    try {
      // On iOS, image_picker handles permissions internally
      // Just try to pick and it will show the system permission dialog

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        final savedPath = await _saveImageToLocalStorage(image.path);
        setState(() {
          _imagePaths.insert(0, savedPath);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo added successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking photo: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Delete a photo
  Future<void> _deletePhoto(int index) async {
    final imagePath = _imagePaths[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }

        setState(() {
          _imagePaths.removeAt(index);
        });

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Photo deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting photo: $e')));
        }
      }
    }
  }

  // Show image in fullscreen
  void _showFullScreenImage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(imagePath: imagePath),
      ),
    );
  }

  // Show options bottom sheet
  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          if (_imagePaths.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '${_imagePaths.length} ${_imagePaths.length == 1 ? 'photo' : 'photos'}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _imagePaths.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No photos yet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add photos',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(_imagePaths[index]),
                  onLongPress: () => _deletePhoto(index),
                  child: Hero(
                    tag: _imagePaths[index],
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: FileImage(File(_imagePaths[index])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showOptions,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const FullScreenImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(File(imagePath)),
          ),
        ),
      ),
    );
  }
}
