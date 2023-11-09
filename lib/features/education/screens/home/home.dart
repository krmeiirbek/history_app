import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:history_app/common/widgets/home/home_buttons.dart';
import 'package:history_app/common/widgets/images/t_circular_image.dart';
import 'package:history_app/features/education/controllers/dummy_data.dart';
import 'package:history_app/features/education/screens/list_books/list_books.dart';
import 'package:history_app/utils/constants/colors.dart';
import 'package:history_app/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// -- Header
          TPrimaryHeaderContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -- Header
                TAppBar(
                  showBackArrowIcon: false,
                  title: Text(
                    'Басты бет',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                  actions: [
                    Row(
                      children: [
                        Text(
                          "🌕 ${TDummyData.user.balance}",
                          style:
                              Theme.of(context).textTheme.titleSmall!.apply(
                                    color: TColors.white,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Hero(
                      tag: 'avatar',
                      child: TCircularImage(
                        padding: 0,
                        image: TDummyData.user.profilePicture,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => HomeButtons(
                title: TDummyData.subjects[index].title,
                image: TDummyData.subjects[index].image,
                onPressed: () => Get.to(
                      () => ListBooksScreen(
                    books: TDummyData.subjects[index].books,
                        title: TDummyData.subjects[index].title,
                  ),
                ),
              ),
              separatorBuilder: (_, __) =>
                  const SizedBox(height: TSizes.spaceBtwSections),
              itemCount: TDummyData.subjects.length,
            ),
          ),
        ],
      ),
    );
  }
}
