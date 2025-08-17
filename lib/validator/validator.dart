//email validator
String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email field cannot be empty.';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Enter a valid email address.';
  }
  return null;
}

//password 
String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password field cannot be empty.';
  }
  
  final hasMinLength = value.length >= 6;
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
  final hasDigit = RegExp(r'\d').hasMatch(value);
  final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  if (!hasMinLength) {
    return 'Password must be at least 6 characters.';
  }
  if (!hasUppercase) {
    return 'Password must include an uppercase letter.';
  }
  if (!hasDigit) {
    return 'Password must include a number.';
  }
  if (!hasSpecial) {
    return 'Password must include a special character.';
  }

  return null;
}

//username
String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username field cannot be empty';
  }
  if (value.length <= 3) {
    return 'Username must be atleast 3 characters.';
  }
  return null;
}


