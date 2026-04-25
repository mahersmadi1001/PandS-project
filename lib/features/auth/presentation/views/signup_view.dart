import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/helper/app_validators.dart';
import 'package:p/core/shared/widgets/TFF.dart';
import 'package:p/core/shared/widgets/custom_button.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/presentation/view_model/bloc/register_bloc.dart';

import 'package:p/features/auth/presentation/views/login_view.dart';
import 'package:uuid/uuid.dart';

class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController valPasswordController = TextEditingController();

  bool visibility_password = true;

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
              height: 650.h,
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
                  Expanded(
                    child: Tff(
                      controller: fullNameController,
                      validator: (value) {
                        return AppValidators.validateName(value);
                      },
                      label: "Full Name",
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: Tff(
                      controller: emailController,
                      validator: (value) {
                        return AppValidators.validateEmail(value);
                      },
                      label: "Email",
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: Tff(
                      controller: phoneController,
                      validator: (value) {
                        return AppValidators.validateSyrianPhone(value);
                      },
                      label: "Phone",
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: Tff(
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
                      controller: passwordController,
                      validator: (value) {
                        return AppValidators.validatePassword(value);
                      },
                      label: "Password",
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: Tff(
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
                      controller: valPasswordController,
                      validator: (value) {
                        if (passwordController.text != value) {
                          return "password is not valid";
                        }
                      },
                      label: "Validate Password",
                    ),
                  ),
                  SizedBox(height: 30.h),

                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      switch (state) {
                        case RegisterSucssfoled():
                        case RegisterInitial():
                          return CustomButton(
                            buttonText: "Registration",
                            ontap: () {
                              if (signUpKey.currentState!.validate()) {
                                try {
                                  context.read<RegisterBloc>().add(
                                    SginupEvent(
                                      user: UserEntity(
                                        uId: Uuid().v4(),
                                        fullName: fullNameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          );

                        case RegisterLoading():
                          return CircularProgressIndicator();

                        case RegisterError():
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.massege)),
                          );
                          return CustomButton(
                            buttonText: "Registration",
                            ontap: () {
                              try {} catch (e) {}
                              if (signUpKey.currentState!.validate()) {
                                try {
                                  context.read<RegisterBloc>().add(
                                    SginupEvent(
                                      user: UserEntity(
                                        uId: Uuid().v4(),
                                        fullName: fullNameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          );
                      }
                    },
                  ),

                  // ),
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
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
