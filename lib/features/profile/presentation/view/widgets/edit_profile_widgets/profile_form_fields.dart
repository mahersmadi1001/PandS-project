import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/neu_PE_text_field.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/staggered_fadeside.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController professionController;
  final TextEditingController skillsController;
  final TextEditingController profileLinkController;
  final VoidCallback onCopyLink;

  const ProfileFormFields({
    super.key,
    required this.nameController,
    required this.bioController,
    required this.professionController,
    required this.skillsController,
    required this.profileLinkController,
    required this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StaggeredFadeSlide(
          index: 1,
          child: NeuPETextField(
            controller: nameController,
            label: 'profile.name'.tr(),
            hint: 'profile.enter_name'.tr(),
            icon: Icons.person_outline,
          ),
        ),
        SizedBox(height: 20.h),
        StaggeredFadeSlide(
          index: 2,
          child: NeuPETextField(
            controller: bioController,
            label: 'profile.bio'.tr(),
            hint: 'profile.enter_bio'.tr(),
            icon: Icons.info_outline,
            maxLines: 3,
          ),
        ),
        SizedBox(height: 20.h),
        StaggeredFadeSlide(
          index: 3,
          child: NeuPETextField(
            controller: professionController,
            label: 'profile.profession'.tr(),
            hint: 'profile.enter_profession'.tr(),
            icon: Icons.work_outline,
          ),
        ),
        SizedBox(height: 20.h),
        StaggeredFadeSlide(
          index: 4,
          child: NeuPETextField(
            controller: skillsController,
            label: 'profile.skills'.tr(),
            hint: 'profile.enter_skills'.tr(),
            icon: Icons.psychology,
          ),
        ),
        SizedBox(height: 20.h),
        StaggeredFadeSlide(
          index: 5,
          child: NeuPETextField(
            controller: profileLinkController,
            label: 'profile.profile_link'.tr(),
            hint: 'profile.profile_link'.tr(),
            icon: Icons.link,
            suffixIcon: IconButton(
              icon: Icon(Icons.copy, color: Colors.blue),
              onPressed: onCopyLink,
            ),
          ),
        ),
      ],
    );
  }
}
