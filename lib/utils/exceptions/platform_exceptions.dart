class TPlatformExceptions implements Exception {
  final String code;

  TPlatformExceptions(this.code);

  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Кіру тіркелгі деректері жарамсыз. Ақпаратыңызды екі рет тексеріңіз.';
      case 'too-many-requests':
        return 'Тым көп сұраулар. Тағы жасауды сәл кейінірек көріңізді өтінеміз.';
      case 'invalid-argument':
        return 'Аутентификация әдісіне берілген жарамсыз аргумент.';
      case 'invalid-password':
        return 'Қате құпиясөз. Қайталап көріңіз.';
      case 'invalid-phone-number':
        return 'Берілген телефон нөмірі жарамсыз.';
      case 'operation-not-allowed':
        return 'Жүйеге кіру провайдері негізгі жобаңыз үшін өшірілген.';
      case 'session-cookie-expired':
        return 'Негізгі сеанс cookie файлының мерзімі аяқталды. Жүйеге қайта кіріңіз.';
      case 'uid-already-exists':
        return 'Берілген пайдаланушы идентификаторын басқа пайдаланушы пайдалануда.';
      case 'sign_in_failed':
        return 'Жүйеге кіру сәтсіз аяқталды. Қайталап көріңіз.';
      case 'network-request-failed':
        return 'Желі сұрауы орындалмады. Интернет байланысын тексеріңіз.';
      case 'internal-error':
        return 'Ішкі қате. Әрекетті кейінірек қайталаңыз.';
      case 'invalid-verification-code':
        return 'Жарамсыз растау коды. Жарамды кодты енгізіңіз.';
      case 'invalid-verification-id':
        return 'Жарамсыз растау идентификаторы. Жаңа растау кодын сұраңыз.';
      case 'quota-exceeded':
        return 'Ішкі қате. Кейінірек қайталап көріңіз.';
      // Add more cases as needed…
      default:
        return 'Платформада күтпеген қате пайда болды. Қайталап көріңіз.';
    }
  }
}
