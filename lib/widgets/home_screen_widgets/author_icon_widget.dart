import 'package:flutter/material.dart';

class AuthorIcon extends StatelessWidget {
  final String label;
  final String imageUrl;

  const AuthorIcon({super.key, required this.label, required this.imageUrl});

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