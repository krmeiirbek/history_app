import 'package:flutter/material.dart';
import 'package:history_app/common/widgets/appbar/appbar.dart';
import 'package:history_app/features/education/screens/application/widgets/application_body.dart';
import 'package:history_app/utils/helpers/helper_functions.dart';

class ApplicationScreen extends StatelessWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Қолданба туралы',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: const ApplicationBody(),
    );
  }
}
