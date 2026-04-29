import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/helper/app_validators.dart';
import 'package:p/core/shared/widgets/TFF.dart';
import 'package:p/core/shared/widgets/custom_button.dart';

import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/presentation/views/signup_view.dart';
import 'package:p/view_temp/nav_bar.dart';

bool visibility_password = true;

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordLoginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: loginKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(),
            Container(
              height: 400.h,
              width: 400.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.r)),
                color: AppColors.lightBlue,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Tff(
                    controller: emailController,
                    validator: (value) {
                      return AppValidators.validateEmail(value);
                    },
                    label: "Email",
                  ),
                  SizedBox(height: 40.h),
                  Tff(
                    obscureText: visibility_password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        color: AppColors.textSecondaryDark,
                        visibility_password
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          visibility_password = !visibility_password;
                        });
                      },
                    ),
                    controller: passwordLoginController,
                    validator: (value) {
                      return AppValidators.validatePassword(value);
                    },
                    label: "Password",
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    buttonText: "Entry",
                    ontap: () {
                      if (loginKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you don't have an account :",
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
                              builder: (context) {
                                return SignUpView();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
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
