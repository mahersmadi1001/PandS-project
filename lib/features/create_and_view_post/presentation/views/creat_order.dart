import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/custom_text_field.dart';
import 'package:p/core/shared/widgets/snack_bar_widget.dart';

import 'package:p/core/shared/widgets/title_app_bar.dart';

import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/create_post/create_post_bloc.dart';
import 'package:p/core/shared/helper/app_validators.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/button_show_list_address.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/button_show_list_category.dart';

import 'package:p/features/create_and_view_post/presentation/widgets/chips_widet.dart';

import 'package:p/core/shared/nav_bar.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/upload_box.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final titleController = TextEditingController();
  final budgetController = TextEditingController();
  final descriptionController = TextEditingController();

  PostType _selectedPostType = PostType.offer;
  String? selectedCategory;
  String? selectedProvince;
  File? _selectedImage;

  final _formKey = GlobalKey<FormState>();
  String? _currentUserId;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    context.read<CreatePostBloc>().add(LoadUserData());
  }

  @override
  void dispose() {
    titleController.dispose();
    budgetController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool validateForm() {
    final validationError = AppValidators.getFirstValidationError(
      title: titleController.text.trim(),
      category: selectedCategory,
      province: selectedProvince,
      budget: budgetController.text.trim(),
      description: descriptionController.text.trim(),
      imageFile: _selectedImage,
    );

    if (validationError != null) {
      showErrorSnackBar(context: context, message: validationError);
      return false;
    }

    return true;
  }

  void _submitForm() {
    if (!validateForm()) return;

    if (_currentUserId == null || _currentUserName == null) {
      showErrorSnackBar(
        context: context,
        message: 'User data not loaded. Please try again.',
      );
      context.read<CreatePostBloc>().add(LoadUserData());
      return;
    }

    context.read<CreatePostBloc>().add(
      CreatePostSubmitted(
        creatorId: _currentUserId!,
        creatorName: _currentUserName!,
        postType: _selectedPostType,
        category: selectedCategory!,
        description: descriptionController.text.trim(),
        province: selectedProvince!,
        price: budgetController.text.trim(),
        imageFile: _selectedImage!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          showSuccessSnackBar(
            message: "Post created successfully",
            context: context,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else if (state is CreatePostUserLoaded) {
          setState(() {
            _currentUserId = state.userId;
            _currentUserName = state.userName;
          });
        }
      },
      child: BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
          final isLoading =
              state is CreatePostUploadingImage ||
              state is CreatePostSaving ||
              state is CreatePostLoadingUser;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryBlue,
              title: TitleAppBar(title: "Create Post"),
            ),
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: "Title",
                            hint:
                                "Example: professional logo design is required",
                            controller: titleController,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonShowListCategory(
                                  selectedCategory:
                                      selectedCategory ?? "Categories",
                                  onCategorySelected: (category) {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: ButtonShowListAddrees(
                                  selectedProvince:
                                      selectedProvince ?? "Address",
                                  onProvinceSelected: (province) {
                                    setState(() {
                                      selectedProvince = province;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomTextField(
                                  label: "Budget",
                                  hint: "50\$",
                                  controller: budgetController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),

                              SizedBox(width: 15.w),

                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Type Post",
                                      style: TextStyle(
                                        color: AppColors.primaryBlue,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    // SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: PostTypeToggle(
                                            selectedType: _selectedPostType,
                                            onSelected: (value) {
                                              setState(() {
                                                _selectedPostType = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            label: "Detailed description",
                            hint: "Explain what you need in detail...",
                            maxLines: 4,
                            controller: descriptionController,
                          ),

                          UploadBox(
                            selectedImage: _selectedImage,
                            onImageSelected: (image) {
                              setState(() {
                                _selectedImage = image;
                              });
                            },
                          ),

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
                              onPressed: isLoading ? null : _submitForm,
                              child: isLoading
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      "Create",
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
        },
      ),
    );
  }
}
