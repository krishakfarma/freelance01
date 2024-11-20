
import 'package:ebook_reader/services/providers/author_provider.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:ebook_reader/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AuthorScreen extends StatelessWidget {
  const AuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: AppColor.appBarBackgroundColor,
      child: ChangeNotifierProvider(
        create: (_) => AuthorProvider(),
        child: Consumer<AuthorProvider>(
          builder: (context, authorProvider, _) => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: authorProvider.authors.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              NetworkImage(authorProvider.authors[index].profileImageUrl ?? AppConstants.userIconLink),
                        ),
                        const SizedBox(height: 4),
                        Text(authorProvider.authors[index].name, style: const TextStyle(fontSize: 14)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

