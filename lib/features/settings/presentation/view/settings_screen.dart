import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/setting_item.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/data/datasources/local.dart';
import 'package:p/features/auth/presentation/views/login_view.dart';
import 'package:p/core/presentation/view_model/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/presentation/view_model/language_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSourceImpl();

  Future<void> _logout() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.confirm_logout'.tr()),
        content: Text('settings.confirm_logout_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('settings.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('settings.confirm'.tr()),
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

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        }
      } catch (e) {
        print('Error during logout: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('settings.logout_error'.tr() + ': $e')),
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

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, languageState) {
            final currentLanguage = languageState is LanguageLoaded
                ? languageState.locale.languageCode
                : 'en';

            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primaryBlue,
                title: TitleAppBar(title: "navigation.settings".tr()),
              ),
              body: Directionality(
                textDirection: currentLanguage == 'ar'
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      SettingsTile(
                        title: "settings.language".tr(),
                        subtitle: currentLanguage == 'ar'
                            ? "العربية"
                            : "English",
                        icon: Icons.language,
                        onTap: () {
                          context.read<LanguageCubit>().toggleLanguage(context);
                        },
                      ),

                      SettingsTile(
                        title: "settings.theme".tr(),
                        subtitle: isDarkMode
                            ? "settings.dark_mode".tr()
                            : "settings.light_mode".tr(),
                        icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        onTap: () {
                          context.read<ThemeBloc>().add(
                            ThemeChanged(isDarkMode: !isDarkMode),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                !isDarkMode
                                    ? 'settings.dark_mode_enabled'.tr()
                                    : 'settings.light_mode_enabled'.tr(),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                      SettingsTile(
                        title: "settings.notifications".tr(),
                        subtitle: "settings.notifications_subtitle".tr(),
                        icon: Icons.notifications_none,
                      ),
                      SettingsTile(
                        title: "settings.security".tr(),
                        subtitle: "settings.security_subtitle".tr(),
                        icon: Icons.lock_outline,
                      ),
                      const Spacer(),
                      SettingsTile(
                        title: "settings.logout".tr(),
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
      },
    );
  }
}
