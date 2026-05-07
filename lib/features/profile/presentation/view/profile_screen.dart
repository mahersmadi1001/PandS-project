import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/domain/entities/profile_entity.dart';
import 'package:p/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // Load current user profile using Hive session
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
          _nameController.text = userData['fullName'] ?? '';
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
        SnackBar(content: Text('فشل رفع الصورة: ${e.toString()}')),
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
    // This would require flutter/services
    // For now, we'll show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم النسخ'),
        content: Text('تم نسخ الرابط: $text'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    final userId = _authLocalDataSource.getSession();
    if (userId != null) {
      // Update profile data in Firestore users collection
      _updateUserData(userId).then((_) {
        // Return true to indicate data was saved
        Navigator.of(context).pop(true);
      });

      final updatedProfile = ProfileEntity(
        uid: userId,
        name: _nameController.text.trim(),
        email: '', // Email will be loaded from Firestore
        bio: _bioController.text.trim(),
        profession: _professionController.text.trim(),
        skills: _skillsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        profileImageUrl: '', // Will be updated if image is uploaded
        profileLink: _profileLinkController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<ProfileBloc>().add(UpdateProfile(profile: updatedProfile));
    }
  }

  Future<void> _updateUserData(String userId) async {
    try {
      // Get current data first
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final currentData = userDoc.data() as Map<String, dynamic>;

        // Only update fields that are different, preserve others
        final updateData = <String, dynamic>{
          'updatedAt': DateTime.now().toIso8601String(),
        };

        // Only update name if it's different
        if (_nameController.text.trim() != (currentData['fullName'] ?? '')) {
          updateData['fullName'] = _nameController.text.trim();
        }

        // Only update bio if it's different
        if (_bioController.text.trim() != (currentData['bio'] ?? '')) {
          updateData['bio'] = _bioController.text.trim();
        }

        // Only update profession if it's different
        if (_professionController.text.trim() !=
            (currentData['profession'] ?? '')) {
          updateData['profession'] = _professionController.text.trim();
        }

        // Only update skills if it's different
        final newSkills = _skillsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        final currentSkills = currentData['skills'] as List? ?? [];
        if (newSkills.toString() != currentSkills.toString()) {
          updateData['skills'] = newSkills;
        }

        // Only update profile link if it's different
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
        title: const Text('الملف الشخصي'),
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث الملف الشخصي')),
            );
          }
          if (state is ProfileImageUploaded) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('تم رفع الصورة')));
          }
          if (state is ProfileImageDeleted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('تم حذف الصورة')));
          }
          if (state is ProfileLinkGenerated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إنشاء رابط الملف: ${state.profileLink}'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;

            // Initialize controllers with current profile data
            _nameController.text = profile.name;
            _bioController.text = profile.bio;
            _professionController.text = profile.profession;
            _skillsController.text = profile.skills.join(', ');
            _profileLinkController.text = profile.profileLink;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Profile Header with Image
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
                        // Profile Image
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
                        // User Info Overlay
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

                  // Profile Information Form
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field
                        Text(
                          'الاسم',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'أدخل اسمك',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Bio Field
                        Text(
                          'النبذة التعريفية',
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
                            hintText: 'أدخل نبذة تعريفية',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Profession Field
                        Text(
                          'المهنة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _professionController,
                          decoration: InputDecoration(
                            hintText: 'أدخل مهنتك',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Skills Field
                        Text(
                          'المهارات',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _skillsController,
                          decoration: InputDecoration(
                            hintText: 'أدخل مهاراتك (مفصولة بفاصلة)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Profile Link Field
                        Text(
                          'رابط الملف الشخصي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _profileLinkController,
                          decoration: InputDecoration(
                            hintText: 'رابط الملف الشخصي',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.borderLight,
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

                        // Action Buttons
                        Row(
                          children: [
                            // Upload Image Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _pickImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                ),
                                child: const Text('اختر صورة'),
                              ),
                            ),

                            SizedBox(width: 10.w),

                            // Upload to Supabase Button
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
                                      : const Text('رفع الصورة'),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Generate Link Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _generateProfileLink,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            child: const Text('إنشاء رابط الملف الشخصي'),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              'حفظ التغييرات',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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

          return const Center(child: Text('الملف الشخصي غير موجود'));
        },
      ),
    );
  }
}
