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
            'Электрондық пошта мекенжайының форматы. жарамсыз. Жарамды электрондық поштаны енгізіңіз.');
      case 'invalid-phone-number-format':
        return const TFormatExceptions(
            'Берілген телефон нөмірі форматы. жарамсыз. Жарамды нөмірді енгізіңіз.');
      case 'invalid-date-format':
        return const TFormatExceptions(
            'Күн форматы. жарамсыз. Жарамды күнді енгізіңіз.');
      case 'invalid-url-format':
        return const TFormatExceptions(
            'URL форматы. жарамсыз. Жарамды URL мекенжайын енгізіңіз.');
      case 'invalid-credit-card-format':
        return const TFormatExceptions(
            'Несие картасының форматы. жарамсыз. Жарамды несие картасының нөмірін енгізіңіз.');
      case 'invalid-numeric-format':
        return const TFormatExceptions(
            'Енгізу жарамды сандық форматы. болуы керек.');
      default:
        return const TFormatExceptions();
    }
  }
}
