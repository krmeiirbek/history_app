class TExceptions implements Exception {
  final String code;

  TExceptions(this.code);

  String get message {
    switch (code) {

    ///
    ///
      default:
        return 'біршама қате';
    }
  }
}
