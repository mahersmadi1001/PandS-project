import 'dart:io';

class AppValidators {
  static final RegExp _nameRegex = RegExp(r'^[\u0600-\u06FFa-zA-Z\s]{2,30}$');

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _syrianPhoneRegex = RegExp(r'^09[3-9][0-9]{7}$');
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
  );

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter the name';
    if (!_nameRegex.hasMatch(value))
      return "The name must contain letters only";
    return null;
  }

  static String? validateSyrianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter the phone number";
    }

    if (!_syrianPhoneRegex.hasMatch(value.trim())) {
      return "Incorrect phone number (example: 09xxxxxxxx)";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter the email";
    if (!_emailRegex.hasMatch(value)) return "The email format is incorrect";
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter the password";
    if (!_passwordRegex.hasMatch(value)) {
      return "It must contain uppercase and lowercase letters, numbers, and symbols";
    }
    return null;
  }

  // Post creation validation methods
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters long';
    }
    if (value.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  static String? validateProvince(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a province';
    }
    return null;
  }

  static String? validateBudget(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a budget';
    }

    final budgetValue = double.tryParse(value.trim());
    if (budgetValue == null) {
      return 'Please enter a valid number';
    }
    if (budgetValue <= 0) {
      return 'Budget must be greater than 0';
    }
    if (budgetValue > 1000000) {
      return 'Budget seems too high';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long';
    }
    if (value.trim().length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }

  static String? validateImage(File? imageFile) {
    if (imageFile == null) {
      return 'Please upload an image';
    }

    // Check file size (max 5MB)
    final fileSize = imageFile.lengthSync();
    if (fileSize > 5 * 1024 * 1024) {
      return 'Image size must be less than 5MB';
    }

    // Check file extension
    final fileName = imageFile.path.toLowerCase();
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    final hasValidExtension = validExtensions.any(
      (ext) => fileName.endsWith(ext),
    );

    if (!hasValidExtension) {
      return 'Please upload a valid image file (JPG, PNG, or GIF)';
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
