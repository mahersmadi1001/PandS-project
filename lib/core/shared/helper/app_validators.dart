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
}
