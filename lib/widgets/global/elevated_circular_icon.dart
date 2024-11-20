// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ElevatedCircularIconWidget extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  const ElevatedCircularIconWidget({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, // White background color for the button
      shape: const CircleBorder(),
      elevation: 4.0, // Adds shadow to make the button elevated
      child: SizedBox(
        width: 40.0, // Adjust width as needed
        height: 40.0, // Adjust height as needed
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.black,
          ), // Black icon for visibility
          onPressed: onPressed,
          iconSize: 20.0, // Adjust icon size as needed
        ),
      ),
    );
  }
}
