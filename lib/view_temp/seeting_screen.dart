import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/setting_item.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                title: "المظهر",
                subtitle: "الوضع الفاتح",
                icon: Icons.dark_mode_outlined,
              ),
              const SettingsTile(
                title: "الأمان والخصوصية",
                subtitle: "تغيير كلمة المرور وتأمين الحساب",
                icon: Icons.lock_outline,
              ),
              const Spacer(),
              const SettingsTile(
                title: "تسجيل الخروج",
                subtitle: "",
                icon: Icons.logout,
                textColor: AppColors.errorRed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
