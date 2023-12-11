// ignore_for_file: unreachable_switch_case

class TFirebaseAuthExceptions implements Exception {
  final String code;

  TFirebaseAuthExceptions(this.code);

  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Электрондық пошта мекенжайы әлдеқашан тіркелген. Басқа электрондық поштаны пайдаланыңыз.';
      case 'invalid-email':
        return 'Берілген электрондық пошта мекенжайы жарамсыз. Жарамды электрондық поштаны енгізіңіз.';
      case 'weak-password':
        return 'Құпия сөз тым әлсіз. Күшті құпия сөзді таңдаңыз.';
      case 'user-disabled':
        return 'Бұл пайдаланушы тіркелгісі өшірілген. Көмек алу үшін қолдау қызметіне хабарласыңыз';
      case 'user-not-found':
        return 'Кіру мәліметтері жарамсыз. Пайдаланушы табылмады.';
      case 'wrong-password':
        return 'Қате құпиясөз. Құпия сөзіңізді тексеріп, әрекетті қайталаңыз.';
      case 'invalid-verification-code':
        return 'Жарамсыз растау коды. Жарамды кодты енгізіңіз.';
      case 'invalid-verification-id':
        return 'Жарамсыз растау идентификаторы. Жаңа растау кодын сұраңыз.';
      case 'quota-exceeded':
        return 'Квота асып кетті. Тағы жасауды сәл кейінірек көріңізді өтінеміз.';
      case 'email-already-exists':
        return 'Электрондық пошта мекенжайы бұрыннан бар. Басқа электрондық поштаны пайдаланыңыз.';
      case 'provider-already-linked':
        return 'Тіркелгі басқа провайдермен әлдеқашан байланыстырылған.';
      case 'requires-recent-login':
        return 'Бұл операция сезімтал және соңғы аутентификацияны қажет етеді. Жүйеге қайта кіріңіз.';
      case 'credential-already-in-use':
        return 'Бұл тіркелгі деректері әлдеқашан басқа пайдаланушы тіркелгісімен байланыстырылған.';
      case 'user-mismatch':
        return 'Берілген тіркелгі деректері бұрын кірген пайдаланушыға сәйкес келмейді.';
      case 'account-exists-with-different-credential':
        return 'Бір электрондық пошта мекенжайы бар, бірақ кіру тіркелгі деректері басқа тіркелгі бұрыннан бар.';
      case 'operation-not-allowed':
        return 'Бұл операцияға рұқсат етілмейді. Көмек алу үшін қолдау қызметіне хабарласыңыз.';
      case 'expired-action-code':
        return 'Әрекет кодының мерзімі аяқталды. Жаңа әрекет кодын сұраңыз.';
      case 'invalid-action-code':
        return 'Әрекет коды жарамсыз. Кодты тексеріп, әрекетті қайталаңыз.';
      case 'missing-action-code':
        return 'Әрекет коды жоқ. Жарамды әрекет кодын беріңіз.';
      case 'user-token-expired':
        return 'Пайдаланушы таңбалауышының мерзімі аяқталды және аутентификация қажет. Жүйеге қайта кіріңіз.';
      case 'user-not-found':
        return 'Берілген электрондық пошта немесе UID үшін пайдаланушы табылмады.';
      case 'invalid-credential':
        return 'Берілген тіркелгі деректері дұрыс емес немесе мерзімі өтіп кеткен.';
      case 'wrong-password':
        return 'Құпия сөз жарамсыз. Құпия сөзіңізді тексеріп, әрекетті қайталаңыз.';
      case 'user-token-revoked':
        return 'Пайдаланушының таңбалауышы кері қайтарылды. Жүйеге қайта кіріңіз.';
      case 'invalid-message-payload':
        return 'Электрондық пошта үлгісін растау хабарының пайдалы жүктемесі жарамсыз.';
      case 'invalid-sender':
        return 'Электрондық пошта үлгісін жіберуші жарамсыз. Жіберушінің электрондық поштасын растаңыз.';
      case 'invalid-recipient-email':
        return 'Алушының электрондық пошта мекенжайы жарамсыз. Жарамды алушының электрондық поштасын көрсетіңіз.';
      case 'missing-iframe-start':
        return 'Электрондық пошта үлгісінде аттың бастау тегі жоқ.';
      case 'missing-iframe-end':
        return 'Электрондық пошта үлгісінде аттың соңы тегі жоқ.';
      case 'missing-iframe-src':
        return 'Электрондық пошта үлгісінде аттың сөз төлсипаты жоқ.';
      case 'auth-domain-config-required':
        return 'Әрекет кодын тексеру сілтемесі үшін аутентификациялық домен конфигурациясы қажет.';
      case 'missing-app-credential':
        return 'Қолданбаның тіркелгі деректері жоқ. Жарамды қолданба тіркелгі деректерін беріңіз.';
      case 'invalid-app-credential':
        return 'Қолданбаның тіркелгі деректері жарамсыз. Жарамды қолданба тіркелгі деректерін беріңіз.';
      case 'session-cookie-expired':
        return 'База сеансының cookie файлының мерзімі аяқталды. Жүйеге қайта кіріңіз.';
      case 'uid-already-exists':
        return 'Берілген пайдаланушы идентификаторын басқа пайдаланушы пайдалануда.';
      case 'invalid-cordova-configuration':
        return 'Берілген Кордова конфигурациясы жарамсыз.';
      case 'app-deleted':
        return 'База қолданбасының бұл данасы жойылды.';
      case 'user-disabled':
        return 'Пайдаланушы тіркелгісі өшірілді.';
      case 'user-token-mismatch':
        return 'Берілген пайдаланушының ID аутентификацияланған пайдаланушының пайдаланушы идентификаторымен сәйкес емес.';
      case 'web-storage-unsupported':
        return 'Веб жадына қолдау көрсетілмейді немесе өшірілген.';
      case 'invalid-credential':
        return 'Берілген тіркелгі деректері жарамсыз. Тіркелгі деректерін тексеріп, әрекетті қайталаңыз.';
      case 'app-not-authorized':
        return 'Қолданбаның берілген API кілтімен Firebase аутентификациясын пайдалануға рұқсаты жоқ.';
      case 'keychain-error':
        return 'Кілттік тізбек қатесі орын алды. Брелокты тексеріп, әрекетті қайталаңыз.';
      case 'internal-error':
        return 'Ішкі аутентификация қатесі орын алды. Тағы жасауды сәл кейінірек көріңізді өтінеміз.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Кіру тіркелгі деректері жарамсыз.';
      default:
        return 'Күтпеген тіркелу қатесі орын алды. Қайталап көріңіз.';
    }
  }
}
