import 'package:ebook_reader/services/routing/app_routes_constants.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
      child: Column(
        children: [
          ElevatedContainer(
            leadingIcon: Icons.favorite_outline,
            name: 'Favorite',
            onTap: () {},
          ),
          ElevatedContainer(
            leadingIcon: Icons.subscriptions_outlined,
            name: 'Subscriptions',
            onTap: () {},
          ),
          ElevatedContainer(
            leadingIcon: Icons.settings_outlined,
            name: 'Settings',
            onTap: () {},
          ),
          ElevatedContainer(
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.signInRoute);
            },
            leadingIcon: Icons.login_outlined,
            name: 'Log in',
          ),
        ],
      ),
    );
  }
}

class ElevatedContainer extends StatelessWidget {
  final IconData leadingIcon;
  final String name;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  const ElevatedContainer({
    Key? key,
    required this.leadingIcon,
    required this.name,
    this.trailingIcon = Icons.arrow_forward_ios,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppColor.appBarBackgroundColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(leadingIcon, color: AppColor.mainOrangeColor), // Icon on the left
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey), // Arrow icon on the right
            ],
          ),
        ),
      ),
    );
  }
}
