import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppValidators {
  static final _nameRegex = RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$');
  static final _syrianPhoneRegex = RegExp(r'^09\d{8}$');
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static String? validateName(String? value, {BuildContext? context}) {
    if (value == null || value.isEmpty)
      return context != null
          ? 'validators.name_required'.tr()
          : 'Please enter the name';
    if (!_nameRegex.hasMatch(value))
      return context != null
          ? 'validators.name_letters_only'.tr()
          : 'The name must contain letters only';
    return null;
  }

  static String? validateSyrianPhone(String? value, {BuildContext? context}) {
    if (value == null || value.isEmpty) {
      return context != null
          ? 'validators.phone_required'.tr()
          : 'Please enter the phone number';
    }

    if (!_syrianPhoneRegex.hasMatch(value.trim())) {
      return context != null
          ? 'validators.phone_incorrect'.tr()
          : 'Incorrect phone number (example: 09xxxxxxxx)';
    }
    return null;
  }

  static String? validateEmail(String? value, {BuildContext? context}) {
    if (value == null || value.isEmpty)
      return context != null
          ? 'validators.email_required'.tr()
          : 'Please enter the email';
    if (!_emailRegex.hasMatch(value))
      return context != null
          ? 'validators.email_incorrect'.tr()
          : 'The email format is incorrect';
    return null;
  }

  static String? validatePassword(String? value, {BuildContext? context}) {
    if (value == null || value.isEmpty)
      return context != null
          ? 'validators.password_required'.tr()
          : 'Please enter the password';
    if (!_passwordRegex.hasMatch(value)) {
      return context != null
          ? 'validators.password_requirements'.tr()
          : 'It must contain uppercase and lowercase letters, numbers, and symbols';
    }
    return null;
  }

  static String? validateTitle(String? value, {BuildContext? context}) {
    if (value == null || value.trim().isEmpty) {
      return context != null
          ? 'validators.title_required'.tr()
          : 'Please enter a title';
    }
    if (value.trim().length < 3) {
      return context != null
          ? 'validators.title_min_length'.tr()
          : 'Title must be at least 3 characters long';
    }
    if (value.trim().length > 100) {
      return context != null
          ? 'validators.title_max_length'.tr()
          : 'Title must be less than 100 characters';
    }
    return null;
  }

  static String? validateCategory(String? value, {BuildContext? context}) {
    if (value == null || value.trim().isEmpty) {
      return context != null
          ? 'validators.category_required'.tr()
          : 'Please select a category';
    }
    return null;
  }

  static String? validateProvince(String? value, {BuildContext? context}) {
    if (value == null || value.trim().isEmpty) {
      return context != null
          ? 'validators.province_required'.tr()
          : 'Please select a province';
    }
    return null;
  }

  static String? validateBudget(String? value, {BuildContext? context}) {
    if (value == null || value.trim().isEmpty) {
      return context != null
          ? 'validators.budget_required'.tr()
          : 'Please enter a budget';
    }

    final budgetValue = double.tryParse(value.trim());
    if (budgetValue == null) {
      return context != null
          ? 'validators.budget_invalid'.tr()
          : 'Please enter a valid number';
    }
    if (budgetValue <= 0) {
      return context != null
          ? 'validators.budget_positive'.tr()
          : 'Budget must be greater than 0';
    }
    if (budgetValue > 1000000) {
      return context != null
          ? 'validators.budget_too_high'.tr()
          : 'Budget seems too high';
    }
    return null;
  }

  static String? validateDescription(String? value, {BuildContext? context}) {
    if (value == null || value.trim().isEmpty) {
      return context != null
          ? 'validators.description_required'.tr()
          : 'Please enter a description';
    }
    if (value.trim().length < 10) {
      return context != null
          ? 'validators.description_min_length'.tr()
          : 'Description must be at least 10 characters long';
    }
    if (value.trim().length > 1000) {
      return context != null
          ? 'validators.description_max_length'.tr()
          : 'Description must be less than 1000 characters';
    }
    return null;
  }

  static String? validateImage(File? imageFile, {BuildContext? context}) {
    if (imageFile == null) {
      return context != null
          ? 'validators.image_required'.tr()
          : 'Please upload an image';
    }
    final fileSize = imageFile.lengthSync();
    if (fileSize > 5 * 1024 * 1024) {
      return context != null
          ? 'validators.image_size_limit'.tr()
          : 'Image size must be less than 5MB';
    }
    final fileName = imageFile.path.toLowerCase();
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    final hasValidExtension = validExtensions.any(
      (ext) => fileName.endsWith(ext),
    );

    if (!hasValidExtension) {
      return context != null
          ? 'validators.image_format'.tr()
          : 'Please upload a valid image file (JPG, PNG, or GIF)';
    }

    return null;
  }

  static bool validatePostForm({
    required String title,
    required String? category,
    required String? province,
    required String budget,
    required String description,
    required File? imageFile,
  }) {
    final titleError = validateTitle(title);
    if (titleError != null) return false;

    final categoryError = validateCategory(category);
    if (categoryError != null) return false;

    final provinceError = validateProvince(province);
    if (provinceError != null) return false;

    final budgetError = validateBudget(budget);
    if (budgetError != null) return false;

    final descriptionError = validateDescription(description);
    if (descriptionError != null) return false;

    final imageError = validateImage(imageFile);
    if (imageError != null) return false;

    return true;
  }

  static String? getFirstValidationError({
    required String title,
    required String? category,
    required String? province,
    required String budget,
    required String description,
    required File? imageFile,
  }) {
    final titleError = validateTitle(title);
    if (titleError != null) return titleError;

    final categoryError = validateCategory(category);
    if (categoryError != null) return categoryError;

    final provinceError = validateProvince(province);
    if (provinceError != null) return provinceError;

    final budgetError = validateBudget(budget);
    if (budgetError != null) return budgetError;

    final descriptionError = validateDescription(description);
    if (descriptionError != null) return descriptionError;

    final imageError = validateImage(imageFile);
    if (imageError != null) return imageError;

    return null;
  }
}
