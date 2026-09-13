import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/profile/presentation/view/profile_edit_screen.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p/features/profile/presentation/view/widgets/info_row.dart';

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
                                _userData!['full_name'] ??
                                    'general.not_specified'.tr(),
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
                        InfoRow(
                          title: "auth.email".tr(),
                          value:
                              _userData!['email'] ??
                              'general.not_specified'.tr(),
                          icon: Icons.email,
                        ),
                        SizedBox(height: 16.h),

                        InfoRow(
                          title: 'profile.phone'.tr(),
                          value:
                              _userData!['phone'] ??
                              'general.not_specified'.tr(),
                          icon: Icons.phone,
                        ),
                        SizedBox(height: 16.h),

                        InfoRow(
                          title: 'profile.bio'.tr(),
                          value: _userData!['bio'] ?? 'profile.no_bio'.tr(),
                          icon: Icons.info_outline,
                        ),
                        SizedBox(height: 16.h),

                        InfoRow(
                          title: 'profile.skills'.tr(),
                          value:
                              _userData!['skills'] != null &&
                                  _userData!['skills'].isNotEmpty
                              ? (_userData!['skills'] as List).join(', ')
                              : 'profile.no_skills'.tr(),
                          icon: Icons.work_outline,
                        ),
                        SizedBox(height: 16.h),

                        if (_userData!['profileLink'] != null &&
                            _userData!['profileLink'].isNotEmpty)
                          InfoRow(
                            title: 'profile.profile_link'.tr(),
                            value: _userData!['profileLink'],
                            icon: Icons.link,
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
}
