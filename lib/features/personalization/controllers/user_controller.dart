import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:history_app/data/repository/authentication/authentication_repository.dart';
import 'package:history_app/data/repository/user/user_repository.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/authentication/screens/login/login.dart';
import 'package:history_app/features/education/controllers/home_controller.dart';
import 'package:history_app/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:history_app/utils/helpers/network_manager.dart';
import 'package:history_app/utils/popups/full_screen_loader.dart';
import 'package:history_app/utils/popups/loaders.dart';
import 'package:history_app/utils/popups/show_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  final imageUploading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final loading = false.obs;
  final _userAuth = AuthenticationRepository.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  @override
  void dispose() {
    verifyEmail.dispose();
    verifyPassword.dispose();
    super.dispose();
  }

  void launchWhatsAppUri() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+77013545050',
      text:
          "Мен TARIH TIME қолданбасындағы теңгерімімді толтырғым келеді.\nМенің USER_ID-ім: ${user.value.id}\nМаған керек сумма",
    );
    await launchUrl(link.asUri());
  }

  void copyToClipboard(String textToCopy, String title) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    // Optionally, show a message that the text was copied.
    TLoaders.successSnackBar(title: '$title көшірілді', duration: 1);
  }

  Future<void> fetchUserRecord() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      await fetchUserRecord();

      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');

          final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
            balance: 0,
            sandyq: ['historyOfKazakhstan_5classroom_1chapter_1quiz'],
          );

          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Деректер сақталмады',
        message: "Ақпаратыңызды сақтау кезінде бірдеңе дұрыс болмады. "
            "Деректерді профильде қайта сақтауға болады",
      );
    }
  }

  void logoutAccount() {
    ShowDialogs.logoutShowDialog(
        title: "Шығу",
        onPressed: () async => _userAuth.logout(),
        middleText: "Есептік жазбадан шыққыңыз келетініне сенімдісіз бе?");
  }

  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image != null) {
        imageUploading.value = true;
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile', image);
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        HomeController.instance.userModel.value.profilePicture = imageUrl;
        user.refresh();
        HomeController.instance.userModel.refresh();
        TLoaders.successSnackBar(
            title: "Құттықтаймын",
            message: "Сіздің профиль суретініз жаңартылды ");
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'О, Жоқ', message: 'Бірдеңе дұрыс емес');
    } finally {
      imageUploading.value = false;
    }
  }

  void deleteAccountWarningPopup() {
    ShowDialogs.deleteShowDialog(
        title: "Есептік жазбаны жою",
        onPressed: () async => deleteUserAccount(),
        middleText: 'Есептік жазбаны біржола жойғыңыз келетініне сенімдісіз бе?'
            ' Бұл әрекетті қайтару мүмкін емес және барлық деректеріңіз біржола жойылады.');
  }

  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog('Өңдеуде', TImages.loading);
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        } else if (provider == 'apple.com') {
          await auth.signInWithApple();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'О, Жоқ', message: e.toString());
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog('Өңдеуде', TImages.loading);

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'О, Жоқ', message: e.toString());
    }
  }
}
