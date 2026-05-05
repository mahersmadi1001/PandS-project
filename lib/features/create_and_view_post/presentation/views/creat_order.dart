import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/widgets/cttf.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/core/string/list_addrees_string.dart';
import 'package:p/core/theme/app_colors.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/create_post/create_post_bloc.dart';
import 'package:p/core/shared/helper/app_validators.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/snack_bar_widjet.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/chips_widet.dart';
import 'package:p/core/shared/widgets/list_address.dart';
import 'package:p/core/shared/widgets/nav_bar.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/upload_box.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _titleController = TextEditingController();
  final _budgetController = TextEditingController();
  final _descriptionController = TextEditingController();

  PostType _selectedPostType = PostType.offer;
  String? _selectedCategory;
  String? _selectedProvince;
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
    _titleController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool validateForm() {
    final validationError = AppValidators.getFirstValidationError(
      title: _titleController.text.trim(),
      category: _selectedCategory,
      province: _selectedProvince,
      budget: _budgetController.text.trim(),
      description: _descriptionController.text.trim(),
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
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        province: _selectedProvince!,
        price: _budgetController.text.trim(),
        imageFile: _selectedImage!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostFailure) {
          showErrorSnackBar(context: context, message: state.message);
        } else if (state is CreatePostSuccess) {
          showSuccessSnackBar(
            context: context,
            message: 'Post created successfully!',
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
                            controller: _titleController,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: AppColors.primaryBlue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadiusGeometry.all(
                                      Radius.circular(16.r),
                                    ),
                                  ),

                                  height: 55.h,
                                  minWidth: 240.w,
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isDismissible: true,
                                      isScrollControlled: true,
                                      backgroundColor: AppColors.cardLight,
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 500.h,
                                          child: Center(
                                            child: ListAddress(
                                              items:
                                                  ConstensApp.serviceCategories,
                                              selectedItem: _selectedCategory,
                                              onSelected: (category) {
                                                setState(() {
                                                  _selectedCategory = category;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Expanded(
                                    child: Row(
                                      spacing: 8.w,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _selectedCategory ?? "Categories",
                                            style: TextStyle(
                                              color: AppColors.primaryBlue,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_downward,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: AppColors.primaryBlue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadiusGeometry.all(
                                      Radius.circular(16.r),
                                    ),
                                  ),

                                  height: 55.h,
                                  minWidth: 240.w,
                                  onPressed: () {
                                    showModalBottomSheet(
                                      isDismissible: true,
                                      backgroundColor: AppColors.cardLight,
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 300.h,
                                          child: Center(
                                            child: ListAddress(
                                              items: ConstensApp
                                                  .syrianGovernorates,
                                              selectedItem: _selectedProvince,
                                              onSelected: (province) {
                                                setState(() {
                                                  _selectedProvince = province;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    spacing: 8.w,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedProvince ?? "Addrees",
                                        style: TextStyle(
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_downward,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ],
                                  ),
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
                                  controller: _budgetController,
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
                            controller: _descriptionController,
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
