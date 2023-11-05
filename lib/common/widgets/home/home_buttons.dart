import 'package:flutter/material.dart';
import 'package:history_app/utils/constants/sizes.dart';

class HomeButtons extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final void Function()? onPressed;

  const HomeButtons({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(left: TSizes.xs),
            child: Row(
              children: [
                SizedBox(
                  height: TSizes.imageTHomeSize,
                  width: TSizes.imageTHomeSize,
                  child: Image(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: TSizes.sizeBoxWidth,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: TSizes.fontSizeLg,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.defaultBtwItems),
                    SizedBox(
                      width: TSizes.sizeBoxWidth,
                      child: Text(
                        subTitle,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
