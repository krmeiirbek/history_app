import 'package:flutter/material.dart';
import 'package:history_app/utils/constants/sizes.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';

class BookButtons extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final void Function()? onPressed;

  const BookButtons({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: dark ? Colors.grey[900]: kDefaultIconLightColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              flex: 5,
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
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: TSizes.sizeBoxWidth,
                    child: Text(
                      subTitle,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium,
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
