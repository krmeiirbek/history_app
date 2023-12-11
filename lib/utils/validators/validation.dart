class TValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName қажет.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Электрондық пошта қажет.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Электрондық пошта мекенжайы жарамсыз.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Құпия сөз қажет.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Құпия сөз кемінде 6 таңбадан тұруы керек.';
    }



    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Телефон нөмірі қажет.';
    }

    // Regular expression for phone number validation
    final phoneRegExp = RegExp(r'^87\d{9}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Жарамсыз телефон нөмірінің форматы. 87xxxxxxxxx пайдаланыңыз';
    }

    return null;
  }

// Add more custom validators as needed for your specific requirements.
}
