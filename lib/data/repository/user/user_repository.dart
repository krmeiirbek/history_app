import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/utils/exceptions/firebase_exceptions.dart';
import 'package:history_app/utils/exceptions/format_exceptions.dart';
import 'package:history_app/utils/exceptions/platform_exceptions.dart';
import 'package:history_app/utils/local_storage/storage_utility.dart';

class UserRepository extends GetxController {
  UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;
  final localStorage = TLocalStorage();

  Future<void> saveUserRecord(UserModel user) async {
    try {
      // Convert the user object to a map and add the 'lastUpdated' field
      var userData = user.toJson();
      userData['lastUpdated'] = DateTime.now();

      // Save the updated user data to Firestore
      await _db.collection("Users").doc(user.id).set(userData);
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

  Future<UserModel> getUserData() async {
    try {
      var userModel = UserModel.empty();
      final lastUpdatedLocal = localStorage.readData('currentUserModel_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampForUser();

      DateTime? lastUpdatedLocalDateTime;
      if (lastUpdatedLocal != null) {
        lastUpdatedLocalDateTime = DateTime.tryParse(lastUpdatedLocal);
      }

      if (lastUpdatedLocalDateTime == null || lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final res = await _db.collection("Users").doc(_user!.uid).get();
        userModel = UserModel.fromSnapshot(res);
        await localStorage.saveData('currentUserModel', userModel.toJson());
        await localStorage.saveData('currentUserModel_lastUpdated', lastUpdatedFirebase.toIso8601String());
      } else {
        userModel = UserModel.fromJson(localStorage.readData('currentUserModel'));
      }

      return userModel;
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

  Future<DateTime> _getLastUpdatedTimestampForUser() async {
    try {
      // Fetch the last updated timestamp for the user from Firestore
      // Assuming a 'lastUpdated' field exists in the user's Firestore document
      var userDoc = await _db.collection('Users').doc(_user!.uid).get();
      var lastUpdatedTimestamp = userDoc.data()?['lastUpdated'] as Timestamp?;
      return lastUpdatedTimestamp?.toDate() ?? DateTime.now();
    } catch (e) {
      return DateTime.now(); // Fallback to current time in case of error
    }
  }

}
