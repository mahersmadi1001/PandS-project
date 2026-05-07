import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/theme/app_colors.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  bool _darkMode = false;
  Color _primaryColor = AppColors.primaryBlue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: TitleAppBar(title: "الإعدادات"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark mode toggle
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الوضع الليلي',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'تفعيل الوضع الليلي لتقليل إجهاد العين',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _darkMode,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                        // TODO: Apply theme change
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('سيتم تغيير الوضع'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Color theme selection
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لون السمة الأساسي',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 8.h,
                      children: [
                        _buildColorOption(Colors.blue, 'أزرق'),
                        _buildColorOption(Colors.green, 'أخضر'),
                        _buildColorOption(Colors.orange, 'برتقالي'),
                        _buildColorOption(Colors.purple, 'بنفسجي'),
                        _buildColorOption(Colors.red, 'أحمر'),
                        _buildColorOption(Colors.teal, 'تركوازي'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Font size settings
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حجم الخط',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Slider(
                      value: 14.0,
                      min: 10.0,
                      max: 20.0,
                      divisions: 10,
                      label: '${14.0.toInt()} sp',
                      onChanged: (value) {
                        // TODO: Apply font size change
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('حجم الخط: ${value.toInt()}'),
                            backgroundColor: AppColors.primaryBlue,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Reset button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _darkMode = false;
                    _primaryColor = AppColors.primaryBlue;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إعادة تعيين الإعدادات'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'إعادة تعيين',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, String label) {
    final isSelected = _primaryColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _primaryColor = color;
        });
        // TODO: Apply color change
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم اختيار اللون: $label'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : Border.all(color: Colors.grey[300]!),
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.white, size: 20.w)
            : const SizedBox.shrink(),
      ),
    );
  }
}
