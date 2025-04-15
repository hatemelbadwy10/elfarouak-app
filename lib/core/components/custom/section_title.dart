import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Styles.sectionTitle,
    );
  }
}
