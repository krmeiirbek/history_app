import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:history_app/features/privacy_policy_and_terms_of_use/controllers/terms_of_use_controller.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsOfUseController());
    return FutureBuilder<String>(
      future: controller.fetchMarkdownContent(
          'https://raw.githubusercontent.com/krmeiirbek/history-app-privacy-policy/main/terms_of_use.md'),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return MarkdownPage(markdownContent: snapshot.data ?? '');
        }
      },
    );
  }
}

class MarkdownPage extends StatelessWidget {
  final String markdownContent;

  const MarkdownPage({super.key, required this.markdownContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of use"),
      ),
      body: Markdown(
        data: markdownContent,
      ),
    );
  }
}
