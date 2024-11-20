
import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String label;
  final String imageUrl;

  const CategoryIcon({super.key, required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}