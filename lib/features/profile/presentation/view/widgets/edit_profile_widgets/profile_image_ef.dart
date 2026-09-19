import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/neu_contaner.dart';

class AnimatedEditableAvatar extends StatelessWidget {
  final String imageUrl;
  final File? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback onDeleteImage;

  const AnimatedEditableAvatar({
    super.key,
    required this.imageUrl,
    this.selectedImage,
    required this.onPickImage,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: NeuPContainer(
              shape: BoxShape.circle,
              padding: EdgeInsets.all(6.r),
              child: Container(
                width: 130.r,
                height: 130.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    width: 2,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: selectedImage != null
                        ? FileImage(selectedImage!) as ImageProvider
                        : (imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : const AssetImage('assets/images/logo.png')
                                    as ImageProvider),
                  ),
                ),
              ),
            ),
          ),
          if (imageUrl.isNotEmpty || selectedImage != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: selectedImage != null ? onPickImage : onDeleteImage,
                child: NeuPContainer(
                  shape: BoxShape.circle,
                  padding: EdgeInsets.all(10.r),
                  child: Icon(
                    selectedImage != null ? Icons.edit : Icons.delete_outline,
                    color: selectedImage != null
                        ? AppColors.primaryBlue
                        : Colors.red,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
