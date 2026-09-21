import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/neu_PE_text_field.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/neu_button_ef.dart';
import 'package:p/features/profile/presentation/view/widgets/edit_profile_widgets/profile_image_ef.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/neu_action_button.dart';
import 'package:p/features/profile/presentation/view/widgets/profile_widgets/staggered_fadeside.dart';
import 'package:p/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:p/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _professionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _profileLinkController = TextEditingController();

  File? _selectedImage;
  bool _isUploading = false;
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSourceImpl();

  @override
  void initState() {
    super.initState();

    final userId = _authLocalDataSource.getSession();
    if (userId != null) {
      context.read<ProfileBloc>().add(LoadProfile(uid: userId));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    if (mounted) {
      setState(() {
        _isUploading = true;
      });
    }

    try {
      final userId = _authLocalDataSource.getSession();
      if (userId != null) {
        context.read<ProfileBloc>().add(
          UploadProfileImage(uid: userId, imagePath: _selectedImage!.path),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'profile.image_upload_error'.tr(namedArgs: {'error': e.toString()}),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _deleteProfileImage() async {
    final userId = _authLocalDataSource.getSession();
    if (userId != null) {
      context.read<ProfileBloc>().add(DeleteProfileImage(uid: userId));
    }
  }

  Future<void> _generateProfileLink() async {
    final userId = _authLocalDataSource.getSession();
    if (userId != null) {
      context.read<ProfileBloc>().add(GenerateProfileLink(uid: userId));
    }
  }

  void _copyToClipboard(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('profile.link_copied'.tr()),
        content: Text('profile.link_copied'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('general.ok'.tr()),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    final userId = _authLocalDataSource.getSession();
    if (userId != null) {
      final profile = ProfileEntity(
        uid: userId,
        name: _nameController.text.trim(),
        email: '',
        bio: _bioController.text.trim(),
        profession: _professionController.text.trim(),
        skills: _skillsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        profileLink: _profileLinkController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      context.read<ProfileBloc>().add(UpdateProfile(profile: profile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('profile.upload_failed'.tr())),
              );
            }
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('profile.profile_updated'.tr())),
              );
              Navigator.of(context).pop(true);
            }
            if (state is ProfileImageUploaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('profile.image_uploaded'.tr())),
              );
              if (mounted) {
                setState(() {
                  _isUploading = false;
                  _selectedImage = null;
                });
              }
            }
            if (state is ProfileImageDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('profile.image_deleted'.tr())),
              );
            }
            if (state is ProfileLinkGenerated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('profile.link_generated'.tr())),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileLoaded) {
              final profile = state.profile;

              if (_nameController.text.isEmpty && profile.name.isNotEmpty) {
                if (mounted) {
                  setState(() {
                    _nameController.text = profile.name;
                    _bioController.text = profile.bio;
                    _professionController.text = profile.profession;
                    _skillsController.text = profile.skills.join(', ');
                    _profileLinkController.text = profile.profileLink;
                  });
                }
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NeuActionButton(
                            icon: Icons.arrow_back_ios_new,
                            onTap: () => Navigator.pop(context),
                          ),
                          Text(
                            'profile.personal_profile'.tr(),
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          NeuActionButton(
                            icon: Icons.share,
                            onTap: _generateProfileLink,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          AnimatedEditableAvatar(
                            imageUrl: profile.profileImageUrl,
                            selectedImage: _selectedImage,
                            onPickImage: _pickImage,
                            onDeleteImage: _deleteProfileImage,
                          ),
                          SizedBox(height: 30.h),
                          StaggeredFadeSlide(
                            index: 1,
                            child: NeuPETextField(
                              controller: _nameController,
                              label: 'profile.name'.tr(),
                              hint: 'profile.enter_name'.tr(),
                              icon: Icons.person_outline,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          StaggeredFadeSlide(
                            index: 2,
                            child: NeuPETextField(
                              controller: _bioController,
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
                              controller: _professionController,
                              label: 'profile.profession'.tr(),
                              hint: 'profile.enter_profession'.tr(),
                              icon: Icons.work_outline,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          StaggeredFadeSlide(
                            index: 4,
                            child: NeuPETextField(
                              controller: _skillsController,
                              label: 'profile.skills'.tr(),
                              hint: 'profile.enter_skills'.tr(),
                              icon: Icons.psychology_outlined,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          StaggeredFadeSlide(
                            index: 5,
                            child: NeuPETextField(
                              controller: _profileLinkController,
                              label: 'profile.profile_link'.tr(),
                              hint: 'profile.profile_link'.tr(),
                              icon: Icons.link,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.copy,
                                  color: AppColors.primaryBlue,
                                ),
                                onPressed: () => _copyToClipboard(
                                  _profileLinkController.text,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          StaggeredFadeSlide(
                            index: 6,
                            child: Row(
                              children: [
                                Expanded(
                                  child: NeuButton(
                                    text: 'profile.choose_image'.tr(),
                                    onPressed: _pickImage,
                                    isPrimary: false,
                                  ),
                                ),
                                if (_selectedImage != null) ...[
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: NeuButton(
                                      text: 'profile.upload_image'.tr(),
                                      onPressed: _uploadImage,
                                      isLoading: _isUploading,
                                      isPrimary: true,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          StaggeredFadeSlide(
                            index: 7,
                            child: NeuButton(
                              text: 'profile.save_changes'.tr(),
                              onPressed: _saveProfile,
                              isPrimary: true,
                              isFullWidth: true,
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(child: Text('profile.profile_not_found'.tr()));
          },
        ),
      ),
    );
  }
}
