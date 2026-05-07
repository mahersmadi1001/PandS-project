import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/helper/app_validators.dart';
import 'package:p/core/shared/widgets/TFF.dart';
import 'package:p/core/shared/widgets/custom_button.dart';
import 'package:p/core/shared/widgets/snack_bar_widget.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/auth/domain/entities/user.dart';
import 'package:p/features/auth/presentation/view_model/Register_bloc/register_bloc.dart';

import 'package:p/features/auth/presentation/views/login_view.dart';
import 'package:p/core/shared/nav_bar.dart';
import 'package:uuid/uuid.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegisterBloc>().add(
      RegisterSubmitted(
        user: UserEntity(
          uId: const Uuid().v4(),
          fullName: _fullNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          password: _passwordCtrl.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          showErrorSnackBar(message: state.message, context: context);
        }
        if (state is RegisterSuccess) {
          showSuccessSnackBar(
            message: 'تم إنشاء الحساب بنجاح ✓',
            context: context,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Container(
                    width: 400.w,
                    margin: EdgeInsets.symmetric(horizontal: 18.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: AppColors.lightBlue,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 25.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Tff(
                          controller: _fullNameCtrl,
                          validator: AppValidators.validateName,
                          label: 'Full Name',
                        ),
                        SizedBox(height: 22.h),
                        Tff(
                          controller: _emailCtrl,
                          validator: AppValidators.validateEmail,
                          label: 'Email',
                        ),
                        SizedBox(height: 22.h),
                        Tff(
                          controller: _phoneCtrl,
                          validator: AppValidators.validateSyrianPhone,
                          label: 'Phone',
                        ),
                        SizedBox(height: 22.h),
                        Tff(
                          controller: _passwordCtrl,
                          obscureText: !_showPassword,
                          validator: AppValidators.validatePassword,
                          label: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_rounded,
                              color: AppColors.textSecondaryDark,
                            ),
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Tff(
                          controller: _confirmPasswordCtrl,
                          obscureText: !_showPassword,
                          label: 'Confirm Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordCtrl.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_rounded,
                              color: AppColors.textSecondaryDark,
                            ),
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        state is RegisterLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                buttonText: 'Registration',
                                ontap: _submit,
                              ),
                        SizedBox(height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Do you have an account?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 15.sp,
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
          ),
        );
      },
    );
  }
}
