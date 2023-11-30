class TFormatExceptions implements Exception {
  final String message;

  const TFormatExceptions(
      [this.message =
          'An unexpected format error occurred. Please check your input.']);

  factory TFormatExceptions.fromMessage(String message) =>
      TFormatExceptions(message);

  String get formattedMessage => message;

  factory TFormatExceptions.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const TFormatExceptions(
            'The email address format is invalid. Please enter a valid email.');
      case 'invalid-phone-number-format':
        return const TFormatExceptions(
            'The provided phone number format is invalid. Please enter a valid number.');
      case 'invalid-date-format':
        return const TFormatExceptions(
            'The date format is invalid. Please enter a valid date.');
      case 'invalid-url-format':
        return const TFormatExceptions(
            'The URL format is invalid. Please enter a valid URL.');
      case 'invalid-credit-card-format':
        return const TFormatExceptions(
            'The credit card format is invalid. Please enter a valid credit card number.');
      case 'invalid-numeric-format':
        return const TFormatExceptions(
            'The input should be a valid numeric format.');
      default:
        return const TFormatExceptions();
    }
  }
}
