import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/theme/app_colors.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _ProfileHeaderWidget(),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  const _BioSectionWidget(),
                  SizedBox(height: 16.h),
                  const _SkillsSectionWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderWidget extends StatelessWidget {
  const _ProfileHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250.h,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 50.h),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryBlue, Color(0xFF00B4DB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 46.r,
                backgroundImage: const NetworkImage('https://via.placeholder.com/150'), // ضع مسار صورتك
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'أحمد محمد',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              'مهندس برمجيات | React & Node.js',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BioSectionWidget extends StatelessWidget {
  const _BioSectionWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('النبذة التعريفية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          SizedBox(height: 8.h),
          Text(
            'أعمل في مجال تطوير الويب وتطبيقات الهواتف الذكية لأكثر من 5 سنوات...',
            style: TextStyle(fontSize: 14.sp, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _SkillsSectionWidget extends StatelessWidget {
  const _SkillsSectionWidget();

  @override
  Widget build(BuildContext context) {
    final skills = ['تطوير ويب', 'React', 'Node.js', 'واجهات مستخدم', 'تصميم قواعد بيانات'];
    return Container(
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
          Text('المهارات والخبرات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: skills.map((skill) => Chip(
              label: Text(skill, style: TextStyle(fontSize: 12.sp, color: AppColors.primaryBlue)),
              backgroundColor: AppColors.lightBlue,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}