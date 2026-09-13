import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
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

  Future<void> _pickImage() async {
    if (_isPicking || !mounted) return;

    setState(() {
      _isPicking = true;
    });

    try {
      if (Platform.isAndroid) {
        if (!await Permission.photos.isGranted) {
          final status = await Permission.photos.request();
          if (status != PermissionStatus.granted) {
            final storageStatus = await Permission.storage.request();
            if (storageStatus != PermissionStatus.granted) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Storage permission is required to select images'.tr(),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
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

        if (await file.exists()) {
          widget.onImageSelected(file);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('upload_box.file_not_exist'.tr()),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'upload_box.pick_image_failed'.tr(args: [e.toString()]),
            ),
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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : AppColors.primaryBlue,
            style: BorderStyle.solid,
            width: 1.5,
          ),
          color: widget.selectedImage != null
              ? Colors.transparent
              : (isDark
                    ? Colors.black12
                    : AppColors.primaryBlue.withOpacity(0.05)),
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
                borderRadius: BorderRadius.circular(13.r),
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
                            'errors.invalid_format'.tr(),
                            style: const TextStyle(color: Colors.grey),
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
                    size: 32.w,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'upload_box.upload_image'.tr(),
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
