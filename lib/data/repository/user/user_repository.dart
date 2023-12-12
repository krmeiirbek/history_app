import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/education/controllers/home_controller.dart';
import 'package:history_app/utils/exceptions/firebase_exceptions.dart';
import 'package:history_app/utils/exceptions/format_exceptions.dart';
import 'package:history_app/utils/exceptions/platform_exceptions.dart';
import 'package:history_app/utils/local_storage/storage_utility.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;
  final localStorage = TLocalStorage();

  Future<void> saveUserRecord(UserModel user) async {
    try {
      var userRef = _db.collection("Users").doc(user.id);

      // Check if the user already exists
      var doc = await userRef.get();
      if (doc.exists) {
        // User already exists, skip saving or handle as needed
        // e.g., update specific fields without overwriting the entire document
        // await userRef.update({ /* specific fields to update */ });
        return;
      }
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
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
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

  Future<void> updateUserRecord(UserModel user) async {
    try {
      // Convert the user object to a map and add the 'lastUpdated' field
      var userData = user.toJson();
      userData['lastUpdated'] = DateTime.now();

      // Save the updated user data to Firestore
      await _db.collection("Users").doc(user.id).update(userData);
      HomeController.instance.userModel.value = user;
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

  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      var userData = updateUser.toJson();
      userData['lastUpdated'] = DateTime.now();
      await _db.collection("Users").doc(updateUser.id).update(userData);
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      json['lastUpdated'] = DateTime.now();
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseExceptions(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatExceptions();
    } on PlatformException catch (e) {
      throw TPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Бірдеңе дұрыс болмады, қайталап көріңіз';
    }
  }

  Future<UserModel> getUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when the user is not logged in
      return UserModel.empty();
    }

    try {
      var userModel = UserModel.empty();
      final lastUpdatedLocal =
          localStorage.readData('currentUserModel_lastUpdated');
      final lastUpdatedFirebase = await _getLastUpdatedTimestampForUser();

      DateTime? lastUpdatedLocalDateTime;
      if (lastUpdatedLocal != null) {
        lastUpdatedLocalDateTime = DateTime.tryParse(lastUpdatedLocal);
      }

      if (lastUpdatedLocalDateTime == null ||
          lastUpdatedFirebase.isAfter(lastUpdatedLocalDateTime)) {
        final res = await _db.collection("Users").doc(currentUser.uid).get();
        userModel = UserModel.fromSnapshot(res);
        await localStorage.saveData('currentUserModel', userModel.toJson());
        await localStorage.saveData('currentUserModel_lastUpdated',
            lastUpdatedFirebase.toIso8601String());
      } else {
        userModel =
            UserModel.fromJson(localStorage.readData('currentUserModel'));
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
