import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
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
