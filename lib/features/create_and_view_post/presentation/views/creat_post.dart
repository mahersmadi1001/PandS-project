import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/helper/app_validators.dart';
import 'package:p/core/shared/nav_bar.dart';
import 'package:p/core/shared/widgets/custom_text_field.dart';
import 'package:p/core/shared/widgets/snack_bar_widget.dart';
import 'package:p/core/shared/widgets/title_app_bar.dart';
import 'package:p/features/create_and_view_post/domain/entities/post_entity.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/create_post/create_post_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/budget_type_post.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/button_submet_form.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/lists_row.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/neu_container.dart';
import 'package:p/features/create_and_view_post/presentation/widgets/upload_box.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  PostType _selectedPostType = PostType.offer;
  String? selectedCategory;
  String? selectedProvince;
  File? _selectedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  void submitForm() {
    if (!validateForm()) return;

    if (_currentUserId == null || _currentUserName == null) {
      showErrorSnackBar(
        context: context,
        message: "create_post.user_data_not_loaded".tr(),
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
        title: titleController.text.trim(),
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
            message: "create_post.post_created_successfully".tr(),
            context: context,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
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
              state is CreatePostUploadingImage || state is CreatePostSaving;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: TitleAppBar(title: "post.create_post".tr()),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NeuContainer(
                              child: CustomTextField(
                                label: "create_post.title".tr(),
                                hint: "create_post.title_hint".tr(),
                                controller: titleController,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ListsRow(),
                            SizedBox(height: 16.h),
                            BudgetandTypePost(
                              selectedPostType: _selectedPostType,
                              budgetController: budgetController,
                            ),
                            SizedBox(height: 16.h),
                            NeuContainer(
                              child: CustomTextField(
                                label: "create_post.detailed_description".tr(),
                                hint: "create_post.description_hint".tr(),
                                maxLines: 4,
                                controller: descriptionController,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            NeuContainer(
                              padding: EdgeInsets.all(10.r),
                              child: UploadBox(
                                selectedImage: _selectedImage,
                                onImageSelected: (image) {
                                  setState(() {
                                    _selectedImage = image;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 28.h),
                            ButtonSubmitForm(
                              isLoading: isLoading,
                              submitForm: submitForm,
                            ),
                            SizedBox(height: 100.h),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
