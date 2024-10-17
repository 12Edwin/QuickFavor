import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

class PhotoPicker extends StatefulWidget {
  final String label;
  final String textDialog;
  final int widthImg;
  final int heightImg;

  const PhotoPicker({super.key, required this.label, required this.textDialog, required this.widthImg, required this.heightImg});

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _takePhoto(StateSetter setState) async {
    setState(() {
      _isLoading = true;
    });

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final File file = File(photo.path);
      final List<int> imageBytes = await file.readAsBytes();
      final img.Image? image = img.decodeImage(imageBytes);
      if (image != null) {
        final img.Image resizedImage = img.copyResize(image, width: widget.widthImg, height: widget.heightImg);
        final List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 50);
        setState(() {
          _base64Image = base64Encode(Uint8List.fromList(compressedBytes));
          _isLoading = false;
        });
      }
    }else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _showCameraDialog,
          label: Text(widget.label),
          icon: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }

  void _showCameraDialog() {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter newState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.textDialog, style: TextStyle(fontSize: 20, color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold)),
                  if (_isLoading)
                    const CircularProgressIndicator(),
                  if (_base64Image == null && !_isLoading)
                     Column(
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(Icons.camera_alt, size: 100, color: Theme.of(context).secondaryHeaderColor,),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                    ),
                    if (_base64Image == null && !_isLoading)
                    ElevatedButton.icon(
                      onPressed: () => _takePhoto(newState),
                      label: const Text('Tomar foto'),
                      icon: const Icon(Icons.camera_alt),
                    ),
                    if (_base64Image != null && !_isLoading)
                    Column(
                      children: [
                        Image.memory(
                          base64Decode(_base64Image!),
                          height: 200,
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _takePhoto(newState),
                          label: const Text('Remplazar foto'),
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}