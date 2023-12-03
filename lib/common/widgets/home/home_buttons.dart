import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: dark ? Colors.grey[900] : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Container(
              height: 190,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) => const Center(
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
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
    );
  }
}
