import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBoxWidget extends StatelessWidget {
  final TextEditingController controller;
  const CustomSearchBoxWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50.0,
        width: kIsWeb ? 250.w : double.infinity, // Adjust this value to change the height
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search books...',
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.search),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0.h), // Adjust this for text padding
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
