import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/helper/app_validators.dart';
import 'package:p/core/shared/widgets/TFF.dart';
import 'package:p/core/shared/widgets/custom_button.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/presentation/views/login_view.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController valPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: signUpKey,
        child: Column(
          children: [
            Row(),
            SizedBox(height: 40.h),

            Container(
              height: 600.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.r)),
                color: AppColors.lightBlue,
              ),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Tff(
                    controller: fullNameController,
                    validator: (value) {
                      AppValidators.validateName(value);
                      return null;
                    },
                    label: "Full Name",
                  ),
                  SizedBox(height: 30.h),
                  Tff(
                    controller: fullNameController,
                    validator: (value) {
                      AppValidators.validateEmail(value);
                      return null;
                    },
                    label: "Email",
                  ),
                  SizedBox(height: 30.h),
                  Tff(
                    controller: fullNameController,
                    validator: (value) {
                      AppValidators.validateSyrianPhone(value);
                      return null;
                    },
                    label: "Phone",
                  ),
                  SizedBox(height: 30.h),
                  Tff(
                    controller: fullNameController,
                    validator: (value) {
                      AppValidators.validatePassword(value);
                      return null;
                    },
                    label: "Password",
                  ),
                  SizedBox(height: 30.h),
                  Tff(
                    controller: fullNameController,
                    validator: (value) {
                      return null;
                    },
                    label: "Validate Password",
                  ),
                  SizedBox(height: 45.h),
                  CustomButton(buttonText: "Registration", ontap: () {}),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do you have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
