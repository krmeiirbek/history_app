// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import '../../../utils/constants/sizes.dart';

class TopicsList extends StatelessWidget {
  TopicsList({
    super.key,
    required this.topics,
  });

  dynamic topics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Topics",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView.separated(
          itemBuilder: (_, index) {
            return ListTile(
              onTap: (){},
              leading: Text(
                topics[index].id,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(fontSizeDelta: TSizes.dividerHeight),
              ),
              title: Text(
                topics[index].title,
              ),
            );
          },
          separatorBuilder: (_, index) => const Divider(height: 1),
          itemCount: topics.length,
        ),
      ),
    );
  }
}
