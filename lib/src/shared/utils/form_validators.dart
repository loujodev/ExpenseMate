class FormValidators {
  /// Validate an email adress
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }

    //email Regex
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid mail';
    }

    return null;
  }

  ///Validate a password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password needs to contain at least 6 symbols';
    }

    return null;
  }

  /// Validiert die Passwortbestätigung
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validiert einen Namen
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }

    if (value.length < 2) {
      return 'Your name must contain at least two characters';
    }

    return null;
  }

  /// Validiert ein allgemeines Textfeld
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }

    return null;
  }
}
