import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/utils/exceptions/firebase_exceptions.dart';
import 'package:history_app/utils/exceptions/format_exceptions.dart';
import 'package:history_app/utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again';
    }
  }
}
