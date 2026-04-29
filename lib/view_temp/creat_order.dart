import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/cttf.dart';
import 'package:p/core/theme/app_colors.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء طلب")),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              const CustomTextField(
                label: "عنوان الطلب",
                hint: "مثال: مطلوب تصميم شعار احترافي",
              ),
              const CustomTextField(
                label: "التصنيف",
                hint: "اختر التصنيف المناسب",
              ),
              Row(
                children: const [
                  Expanded(
                    child: CustomTextField(
                      label: "الميزانية التقديرية",
                      hint: "50\$",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextField(label: "إلى", hint: "200\$"),
                  ),
                ],
              ),
              const CustomTextField(
                label: "وصف تفصيلي",
                hint: "اشرح ما تحتاجه بالتفصيل...",
                maxLines: 4,
              ),

              // Upload Area
              const UploadBox(),

              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "إنشاء الطلب",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadBox extends StatelessWidget {
  const UploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue.shade100,
          style: BorderStyle.solid,
        ), // يمكنك استخدام dotted_border package هنا
        color: Colors.blue.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.primaryBlue,
            size: 30.w,
          ),
          SizedBox(height: 10.h),
          Text(
            "انقر هنا لرفع الصور أو الملفات",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
