import 'package:flutter/material.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      'logout_confirmation': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'notifications': 'Notifications',
      'notifications_subtitle': 'Customize message and request notifications',
      'language': 'Language',
      'arabic': 'Arabic',
      'english': 'English',
      'appearance': 'Appearance',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'security_privacy': 'Security & Privacy',
      'security_subtitle': 'Change password and secure account',
      'name': 'Name',
      'email': 'Email',
      'phone': 'Phone',
      'bio': 'Bio',
      'profession': 'Profession',
      'skills': 'Skills',
      'profile_link': 'Profile Link',
      'upload_image': 'Upload Image',
      'save_profile': 'Save Profile',
      'no_data': 'No data available',
      'profile_updated': 'Profile updated successfully',
      'error_occurred': 'An error occurred',
      'logout_success': 'Logged out successfully',
      'logout_error': 'Error during logout',
    },
    'ar': {
      'profile': 'الملف الشخصي',
      'edit_profile': 'تعديل الملف الشخصي',
      'settings': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      'logout_confirmation': 'هل أنت متأكد من تسجيل الخروج؟',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'notifications': 'الإشعارات',
      'notifications_subtitle': 'تخصيص تنبيهات الرسائل والطلبات',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'الإنجليزية',
      'appearance': 'المظهر',
      'light_mode': 'الوضع الفاتح',
      'dark_mode': 'الوضع الداكن',
      'security_privacy': 'الأمان والخصوصية',
      'security_subtitle': 'تغيير كلمة المرور وتأمين الحساب',
      'name': 'الاسم',
      'email': 'البريد الإلكتروني',
      'phone': 'رقم الهاتف',
      'bio': 'النبذة التعريفية',
      'profession': 'المهنة',
      'skills': 'المهارات',
      'profile_link': 'رابط الملف الشخصي',
      'upload_image': 'رفع صورة',
      'save_profile': 'حفظ الملف الشخصي',
      'no_data': 'لا توجد بيانات',
      'profile_updated': 'تم تحديث الملف الشخصي بنجاح',
      'error_occurred': 'حدث خطأ',
      'logout_success': 'تم تسجيل الخروج بنجاح',
      'logout_error': 'خطأ أثناء تسجيل الخروج',
    },
  };

  static String translate(String key, String locale) {
    final languageMap = _localizedValues[locale] ?? _localizedValues['en'];
    return languageMap?[key] ?? key;
  }

  static String getCurrentLanguageName(String locale) {
    switch (locale) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'English';
    }
  }
}

extension AppLocalizationsExtension on BuildContext {
  String get currentLocale => Localizations.localeOf(this).languageCode;

  String tr(String key) {
    return AppLocalizations.translate(key, currentLocale);
  }
}
