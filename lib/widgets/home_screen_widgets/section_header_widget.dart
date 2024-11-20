import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/utils/responsive.dart';
import 'package:ebook_reader/utils/styles.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionHeader({super.key, required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Responsive.isDesktop(context) ? AppStyles.desktopBoldText18 : AppStyles.boldText18,
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            'View all',
            style: TextStyle(color: AppColor.mainOrangeColor),
          ),
        ),
      ],
    );
  }
}
