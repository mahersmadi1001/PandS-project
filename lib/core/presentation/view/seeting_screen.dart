import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/setting_item.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:p/features/auth/presentation/views/login_view.dart';
import 'package:p/core/presentation/view_model/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSourceImpl();

  Future<void> _logout() async {
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
        final userId = _authLocalDataSource.getSession();

        if (userId != null) {
          await _authLocalDataSource.clearSession();

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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState is ThemeLoaded
            ? themeState.isDarkMode
            : false;

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
                    subtitle: isDarkMode ? "الوضع الداكن" : "الوضع الفاتح",
                    icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    onTap: () {
                      context.read<ThemeBloc>().add(
                        ThemeChanged(isDarkMode: !isDarkMode),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            !isDarkMode
                                ? 'تم تفعيل الوضع الليلي'
                                : 'تم تفعيل الوضع النهاري',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
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
                  SettingsTile(
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
      },
    );
  }
}
