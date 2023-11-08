// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/screens/question/question.dart';
import '../../../utils/constants/sizes.dart';

class VersionList extends StatelessWidget {
  VersionList({
    super.key,
    required this.version,
  });

  dynamic version;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Version",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView.separated(
          itemBuilder: (_, index) {
            return ListTile(
              onTap: () => Get.to(
                () =>  const Question(),
              ),
              leading: Text(
                '${index + 1}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(fontSizeDelta: TSizes.dividerHeight),
              ),
              title: Text(
                version[index].title,
              ),
            );
          },
          separatorBuilder: (_, index) => const Divider(height: 1),
          itemCount: version.length,
        ),
      ),
    );
  }
}
