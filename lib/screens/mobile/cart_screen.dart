import 'package:ebook_reader/utils/colors.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.appBarBackgroundColor,
          elevation: 0,
          title: const Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }
}
