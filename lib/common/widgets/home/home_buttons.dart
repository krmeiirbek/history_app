import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';

class HomeButtons extends StatelessWidget {
  final String title;
  final String image;
  final void Function()? onPressed;

  const HomeButtons({
    super.key,
    required this.title,
    required this.image,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Container(
        height: 200,
        width: double.infinity,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: dark ? Colors.grey[800] : Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: dark ? TColors.darkGrey.withOpacity(0.4) :Colors.grey,
              offset: const Offset(1, 1),
            )
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: TSizes.sizeBoxWidth,
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: TSizes.fontSizeLg,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
