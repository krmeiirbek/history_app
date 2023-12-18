import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/features/authentication/models/user_model.dart';
import 'package:history_app/features/personalization/controllers/user_controller.dart';
import 'package:history_app/utils/constants/image_strings.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../images/t_circular_image.dart';

class TUserProfileCard extends StatelessWidget {
  const TUserProfileCard({
    super.key,
    required UserModel user,
    required this.actionButtonOnPressed,
  }) : _user = user;

  final UserModel _user;
  final VoidCallback actionButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading:  Hero(
        tag: 'avatar',
        child:  Obx(
              () {
            final networkImage =
                controller.user.value.profilePicture;
            final image = networkImage.isNotEmpty
                ? networkImage
                : TImages.user;
            return controller.imageUploading.value
                ? const CircularProgressIndicator()
                : TCircularImage(
              isNetworkImage: networkImage.isNotEmpty,
              image: image,
            );
          },
        ),
      ),
      title: Text(_user.fullName,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: TColors.white),
      ),
      subtitle: Text(
        _user.email,
        style:
            Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white),
      ),
      trailing: IconButton(
        onPressed: actionButtonOnPressed,
        icon: const Icon(Iconsax.edit, color: TColors.white),
      ),
    );
  }
}
