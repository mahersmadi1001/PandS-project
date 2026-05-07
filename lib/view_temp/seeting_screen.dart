import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/setting_item.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:p/features/auth/presentation/views/login_view.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSourceImpl();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    // Load theme preference from Hive
    try {
      final themeBox = await Hive.openBox('theme_box');
      final isDark = themeBox.get('is_dark_mode') ?? false;
      setState(() {
        _isDarkMode = isDark;
      });
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  Future<void> _saveThemePreference(bool isDark) async {
    try {
      final themeBox = await Hive.openBox('theme_box');
      await themeBox.put('is_dark_mode', isDark);
      setState(() {
        _isDarkMode = isDark;
      });
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Get current user ID
        final userId = _authLocalDataSource.getSession();

        if (userId != null) {
          // Delete user session from Hive
          await _authLocalDataSource.clearSession();

          // Optional: Delete user document from Firestore
          // await _firestore.collection('users').doc(userId).delete();

          print('User logged out successfully');
        }

        // Navigate to login screen
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        }
      } catch (e) {
        print('Error during logout: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء تسجيل الخروج: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "Settings"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Theme Switch
              SettingsTile(
                title: "المظهر",
                subtitle: _isDarkMode ? "الوضع الداكن" : "الوضع الفاتح",
                icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                onTap: () {
                  _saveThemePreference(!_isDarkMode);
                  // Apply theme change
                  // This would require BLoC implementation for full app theme change
                },
              ),
              const SettingsTile(
                title: "الإشعارات",
                subtitle: "تخصيص تنبيهات الرسائل والطلبات",
                icon: Icons.notifications_none,
              ),
              const SettingsTile(
                title: "اللغة {Language}",
                subtitle: "العربية",
                icon: Icons.language,
              ),
              const SettingsTile(
                title: "الأمان والخصوصية",
                subtitle: "تغيير كلمة المرور وتأمين الحساب",
                icon: Icons.lock_outline,
              ),
              const Spacer(),
              SettingsTile(
                title: "تسجيل الخروج",
                subtitle: "",
                icon: Icons.logout,
                textColor: AppColors.errorRed,
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
