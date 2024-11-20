// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ebook_reader/utils/responsive.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String? price;
  final Function() onTap;

  const BookCard({
    Key? key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Responsive.isDesktop(context) ? 220 : 180, // Increased height for desktop
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            Responsive.isMobile(context)
                ? BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 0,
                    blurRadius: 0,
                  ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: Responsive.isDesktop(context) ? 4 : 3, // Adjust flex for larger images on desktop
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(author, style: const TextStyle(color: Colors.grey)),
                  Text(price == null ? "Free" : "₹$price", style: const TextStyle(color: Colors.black, fontSize: 12.5)),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
