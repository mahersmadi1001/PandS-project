import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p/core/theme/app_colors.dart';

class UploadBox extends StatelessWidget {
  final File? selectedImage;
  final Function(File) onImageSelected;

  const UploadBox({
    super.key,
    this.selectedImage,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 800,
          maxHeight: 600,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          onImageSelected(File(pickedFile.path));
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
          color: selectedImage != null
              ? Colors.transparent
              : Colors.blue.withAlpha(30),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.file(
                  selectedImage!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
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
