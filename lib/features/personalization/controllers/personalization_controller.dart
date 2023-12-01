import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/utils/exceptions/firebase_exceptions.dart';
import 'package:history_app/utils/exceptions/format_exceptions.dart';
import 'package:history_app/utils/exceptions/platform_exceptions.dart';
import 'package:history_app/utils/local_storage/storage_utility.dart';

class PersonalizationController extends GetxController {
  static PersonalizationController get instance => Get.find();

  final _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final localStorage = TLocalStorage();
  var userModel = UserModel.empty();
  final loading = true.obs;

  @override
  void onInit() {
    loading.value = true;
    getUserData();
    loading.value = false;
    super.onInit();
  }

  void getUserData() async {
    try {
      if(localStorage.readData('currentUserModel') == null){
        final res = await _db.collection("Users").doc(_user!.uid).get();
        userModel = UserModel.fromSnapshot(res);
        localStorage.saveData('currentUserModel', userModel.toJson());
      }else{
        userModel = UserModel.fromJson(localStorage.readData('currentUserModel'));
      }
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw e.toString();
    }
  }
}