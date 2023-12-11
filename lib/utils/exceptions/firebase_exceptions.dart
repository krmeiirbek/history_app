class TFirebaseExceptions implements Exception {
  final String code;

  TFirebaseExceptions(this.code);

  String get message {
    switch (code) {
      case 'unknown':
        return 'Белгісіз база қатесі орын алды. Қайталап көріңіз.';
      case 'invalid-custom-token':
        return 'Теңшелетін таңбалауыш пішімі дұрыс емес. Арнаулы таңбалауышыңызды тексеріңіз.';
      case 'custom-token-mismatch':
        return 'Пайдаланушы таңбалауышы басқа аудиторияға сәйкес келеді.';
      case 'user-disabled':
        return 'Пайдаланушы тіркелгісі өшірілді.';
      case 'user-not-found':
        return 'Берілген электрондық пошта немесе UID үшін пайдаланушы табылмады.';
      case 'invalid-email':
        return 'Берілген электрондық пошта мекенжайы жарамсыз. Жарамды электрондық поштаны енгізіңіз.';
      case 'email-already-in-use':
        return 'Электрондық пошта мекенжайы әлдеқашан тіркелген. Басқа электрондық поштаны пайдаланыңыз.';
      case 'wrong-password':
        return 'Қате құпиясөз. Құпия сөзіңізді тексеріп, әрекетті қайталаңыз.';
      case 'weak-password':
        return 'Құпия сөз тым әлсіз. Күшті құпия сөзді таңдаңыз.';
      case 'provider-already-linked':
        return 'Тіркелгі басқа провайдермен әлдеқашан байланыстырылған.';
      case 'operation-not-allowed':
        return 'Бұл операцияға рұқсат етілмейді. Көмек алу үшін қолдау қызметіне хабарласыңыз.';
      case 'invalid-credential':
        return 'Берілген тіркелгі деректері дұрыс емес немесе мерзімі өтіп кеткен.';
      case 'invalid-verification-code':
        return 'Жарамсыз растау коды. Жарамды кодты енгізіңіз.';
      case 'invalid-verification-id':
        return 'Жарамсыз растау идентификаторы. Жаңа растау кодын сұраңыз.';
      case 'captcha-check-failed':
        return 'Қайталау жауабы жарамсыз. Қайталап көріңіз.';
      case 'app-not-authorized':
        return 'Қолданбаның берілген API кілтімен база аутентификациясын пайдалануға рұқсаты жоқ.';
      case 'keychain-error':
        return 'Кілттік тізбек қатесі орын алды. Брелокты тексеріп, әрекетті қайталаңыз.';
      case 'internal-error':
        return 'Ішкі аутентификация қатесі орын алды. Тағы жасауды сәл кейінірек көріңізді өтінеміз.';
      case 'invalid-app-credential':
        return 'Қолданбаның тіркелгі деректері жарамсыз. Жарамды қолданба тіркелгі деректерін беріңіз.';
      case 'user-mismatch':
        return 'Берілген тіркелгі деректері бұрын кірген пайдаланушыға сәйкес келмейді.';
      case 'requires-recent-login':
        return 'Берілген тіркелгі деректері бұрын кірген пайдаланушыға сәйкес келмейді.';
      case 'quota-exceeded':
        return 'Ішкі қате. Тағы жасауды сәл кейінірек көріңізді өтінеміз.';
      case 'account-exists-with-different-credential':
        return 'Бір электрондық пошта мекенжайы бар, бірақ кіру тіркелгі деректері басқа тіркелгі бұрыннан бар.';
      case 'missing-iframe-start':
        return 'Электрондық пошта үлгісінде аттың бастау тегі жоқ.';
      case 'missing-iframe-end':
        return 'Электрондық пошта үлгісінде аттың соңы тегі жоқ.';
      case 'missing-iframe-src':
        return 'Электрондық пошта үлгісінде аттың сөз төлсипаты жоқ.';
      case 'auth-domain-config-required':
        return 'Әрекет кодын тексеру сілтемесі үшін тіркелу конфигурациясы қажет.';
      case 'missing-app-credential':
        return 'Қолданбаның тіркелгі деректері жоқ. Жарамды қолданба тіркелгі деректерін беріңіз.';
      case 'session-cookie-expired':
        return 'Негізгі сеанс cookie файлының мерзімі аяқталды. Жүйеге қайта кіріңіз.';
      case 'uid-already-exists':
        return 'Берілген пайдаланушы идентификаторын басқа пайдаланушы пайдалануда.';
      case 'web-storage-unsupported':
        return 'Веб жадына қолдау көрсетілмейді немесе өшірілген.';
      case 'app-deleted':
        return 'FirebaseApp қолданбасының бұл данасы жойылды.';
      case 'user-token-mismatch':
        return 'Берілген пайдаланушының таңбалауышы аутентификацияланған пайдаланушының пайдаланушы идентификаторымен сәйкес емес.';
      case 'invalid-message-payload':
        return 'Электрондық пошта үлгісін растау хабарының пайдалы жүктемесі жарамсыз.';
      case 'invalid-sender':
        return 'Электрондық пошта үлгісін жіберуші жарамсыз. Жіберушінің электрондық поштасын растаңыз.';
      case 'invalid-recipient-email':
        return 'Алушының электрондық пошта мекенжайы жарамсыз. Жарамды алушының электрондық поштасын көрсетіңіз.';
      case 'missing-action-code':
        return 'Әрекет коды жоқ. Жарамды әрекет кодын беріңіз.';
      case 'user-token-expired':
        return 'Пайдаланушы таңбалауышының мерзімі аяқталды және аутентификация қажет. Жүйеге қайта кіріңіз.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Кіру тіркелгі деректері жарамсыз.';
      case 'expired-action-code':
        return 'Әрекет кодының мерзімі аяқталды. Жаңа әрекет кодын сұраңыз.';
      case 'invalid-action-code':
        return 'Әрекет коды жарамсыз. Кодты тексеріп, әрекетті қайталаңыз.';
      case 'credential-already-in-use':
        return 'Бұл тіркелгі деректері әлдеқашан басқа пайдаланушы тіркелгісімен байланыстырылған.';
      default:
        return 'Күтпеген база қатесі орын алды. Қайталап көріңіз.';
    }
  }
}
