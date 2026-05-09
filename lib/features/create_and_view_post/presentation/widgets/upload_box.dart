import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadBox extends StatefulWidget {
  final File? selectedImage;
  final Function(File) onImageSelected;

  const UploadBox({
    super.key,
    this.selectedImage,
    required this.onImageSelected,
  });

  @override
  State<UploadBox> createState() => _UploadBoxState();
}

class _UploadBoxState extends State<UploadBox> {
  bool _isPicking = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isPicking
          ? null
          : () async {
              if (!mounted) return;

              setState(() {
                _isPicking = true;
              });

              try {
                // Request storage permissions for Android
                if (Platform.isAndroid) {
                  // For Android 13+ (API 33+)
                  if (await Permission.photos.isGranted) {
                    // Permission already granted
                  } else {
                    // Request permission
                    final status = await Permission.photos.request();
                    if (status != PermissionStatus.granted) {
                      // Fallback to storage permission for older Android versions
                      final storageStatus = await Permission.storage.request();
                      if (storageStatus != PermissionStatus.granted) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Storage permission is required to select images',
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                        return;
                      }
                    }
                  }
                }

                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 800,
                  maxHeight: 600,
                  imageQuality: 80,
                );

                if (pickedFile != null && mounted) {
                  final file = File(pickedFile.path);

                  // Verify file exists
                  if (await file.exists()) {
                    widget.onImageSelected(file);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected file does not exist'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                }
              } catch (e) {
                print('Error picking image: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to pick image: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isPicking = false;
                  });
                }
              }
            },
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue.shade100,
            style: BorderStyle.solid,
          ),
          color: widget.selectedImage != null
              ? Colors.transparent
              : Colors.blue.withAlpha(30),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: _isPicking
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryBlue,
                  ),
                ),
              )
            : widget.selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.file(
                  widget.selectedImage!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 30.w,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Error loading image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.primaryBlue,
                    size: 30.w,
                  ),
                  SizedBox(height: 10.h),
                  Text("Upload image"),
                ],
              ),
      ),
    );
  }
}
