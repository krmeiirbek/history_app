import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/screens/login/login.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
    super.onReady();
  }

  screenRedirect() async {
    Get.offAll(() => const LoginScreen());
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (_) {
      throw FirebaseAuthException(code: '');
    } on FirebaseException catch (_) {
      throw FirebaseException(code: '', plugin: '');
    } on FormatException catch (_) {
      throw const FormatException();
    } on PlatformException catch (_) {
      throw PlatformException(code: 'code');
    } catch (e) {
      throw 'Something went wrong, Please try again';
    }
  }
}
