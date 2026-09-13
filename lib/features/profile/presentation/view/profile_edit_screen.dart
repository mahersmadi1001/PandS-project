import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    final userId = _authLocalDataSource.getSession();
    if (userId != null) {
      _loadUserData(userId);
      context.read<ProfileBloc>().add(LoadProfile(uid: userId));
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = userData['full_name'] ?? '';
          _bioController.text = userData['bio'] ?? '';
          _professionController.text = userData['profession'] ?? '';
          _skillsController.text = userData['skills'] != null
              ? (userData['skills'] as List).join(', ')
              : '';
          _profileLinkController.text = userData['profileLink'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
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

    setState(() {
      _isUploading = true;
    });

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
      setState(() {
        _isUploading = false;
        _selectedImage = null;
      });
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
      _updateUserData(userId).then((_) {
        Navigator.of(context).pop(true);
      });
    }
  }

  Future<void> _updateUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final currentData = userDoc.data() as Map<String, dynamic>;

        final updateData = <String, dynamic>{
          'updatedAt': DateTime.now().toIso8601String(),
        };

        if (_nameController.text.trim() != (currentData['full_name'] ?? '')) {
          updateData['full_name'] = _nameController.text.trim();
        }
        if (_bioController.text.trim() != (currentData['bio'] ?? '')) {
          updateData['bio'] = _bioController.text.trim();
        }

        if (_professionController.text.trim() !=
            (currentData['profession'] ?? '')) {
          updateData['profession'] = _professionController.text.trim();
        }

        final newSkills = _skillsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        final currentSkills = currentData['skills'] as List? ?? [];
        if (newSkills.toString() != currentSkills.toString()) {
          updateData['skills'] = newSkills;
        }

        if (_profileLinkController.text.trim() !=
            (currentData['profileLink'] ?? '')) {
          updateData['profileLink'] = _profileLinkController.text.trim();
        }

        await _firestore.collection('users').doc(userId).update(updateData);
        print('User data updated in Firestore');
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleAppBar(title: 'profile.personal_profile'.tr()),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _generateProfileLink,
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
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
          }
          if (state is ProfileImageUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('profile.image_uploaded'.tr())),
            );
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

            _nameController.text = profile.name;
            _bioController.text = profile.bio;
            _professionController.text = profile.profession;
            _skillsController.text = profile.skills.join(', ');
            _profileLinkController.text = profile.profileLink;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, Color(0xFF00B4DB)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (profile.profileImageUrl.isNotEmpty)
                          Positioned(
                            top: 20.h,
                            right: 20.w,
                            child: GestureDetector(
                              onTap: _deleteProfileImage,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 50.r,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 46.r,
                                    backgroundImage:
                                        profile.profileImageUrl.isNotEmpty
                                        ? NetworkImage(profile.profileImageUrl)
                                        : const AssetImage('assets/logo.png'),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                profile.name,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                profile.profession,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.backgroundLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'profile.name'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'profile.enter_name'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.backgroundLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          'profile.bio'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'profile.enter_bio'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.backgroundLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          'profile.profession'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _professionController,
                          decoration: InputDecoration(
                            hintText: 'profile.enter_profession'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.backgroundLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          'profile.skills'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _skillsController,
                          decoration: InputDecoration(
                            hintText: 'profile.enter_skills'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.backgroundLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          'profile.profile_link'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _profileLinkController,
                          decoration: InputDecoration(
                            hintText: 'profile.profile_link'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.backgroundLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () =>
                                  _copyToClipboard(_profileLinkController.text),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                ),
                                child: Text('profile.choose_image'.tr()),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            if (_selectedImage != null)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _uploadImage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: _isUploading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Text('profile.upload_image'.tr()),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _generateProfileLink,

                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(
                                'profile.save_changes'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text('profile.profile_not_found'.tr()));
        },
      ),
    );
  }
}
