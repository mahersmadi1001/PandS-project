import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/profile_image_ef.dart';

class ProfileImageSection extends StatelessWidget {
  final String? imageUrl;
  final File? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback onDeleteImage;

  const ProfileImageSection({
    super.key,
    required this.imageUrl,
    required this.selectedImage,
    required this.onPickImage,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),
        AnimatedEditableAvatar(
          imageUrl: imageUrl ?? '',
          selectedImage: selectedImage,
          onPickImage: onPickImage,
          onDeleteImage: onDeleteImage,
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}
