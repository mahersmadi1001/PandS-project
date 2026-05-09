import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view/profile_screen.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSourceImpl();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data when returning from edit screen
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = _authLocalDataSource.getSession();
      print('User ID from Hive: $userId');

      if (userId != null && userId.isNotEmpty) {
        print('Loading user data for ID: $userId');
        final userDoc = await _firestore.collection('users').doc(userId).get();
        print('User document exists: ${userDoc.exists}');

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          print('User data loaded: $data');
          setState(() {
            _userData = data;
            _isLoading = false;
          });
        } else {
          print('User document does not exist');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('No user ID found in Hive');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _loadUserData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
              // Reload data when returning from edit screen
              if (result == true || mounted) {
                _loadUserData();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData != null
          ? SingleChildScrollView(
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
                        // User Info
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 50.r,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 46.r,
                                  backgroundImage:
                                      _userData!['profileImageUrl'] != null &&
                                          _userData!['profileImageUrl']
                                              .isNotEmpty
                                      ? NetworkImage(
                                          _userData!['profileImageUrl'],
                                        )
                                      : const AssetImage('assets/logo.png'),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                _userData!['full_name'] ?? 'غير محدد',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Profile Information Display
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
                        // Email
                        _buildInfoRow(
                          "auth.email".tr(),
                          _userData!['email'] ?? 'general.not_specified'.tr(),
                          Icons.email,
                        ),
                        SizedBox(height: 16.h),

                        // Phone
                        _buildInfoRow(
                          'profile.phone'.tr(),
                          _userData!['phone'] ?? 'general.not_specified'.tr(),
                          Icons.phone,
                        ),
                        SizedBox(height: 16.h),

                        // Bio
                        _buildInfoRow(
                          'profile.bio'.tr(),
                          _userData!['bio'] ?? 'profile.no_bio'.tr(),
                          Icons.info_outline,
                        ),
                        SizedBox(height: 16.h),

                        // Skills
                        _buildInfoRow(
                          'profile.skills'.tr(),
                          _userData!['skills'] != null &&
                                  _userData!['skills'].isNotEmpty
                              ? (_userData!['skills'] as List).join(', ')
                              : 'profile.no_skills'.tr(),
                          Icons.work_outline,
                        ),
                        SizedBox(height: 16.h),

                        // Profile Link
                        if (_userData!['profileLink'] != null &&
                            _userData!['profileLink'].isNotEmpty)
                          _buildInfoRow(
                            'profile.profile_link'.tr(),
                            _userData!['profileLink'],
                            Icons.link,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(child: Text('profile.profile_not_found'.tr())),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryBlue),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
