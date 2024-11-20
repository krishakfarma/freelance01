import 'package:ebook_reader/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static const String fiorinaFont = 'Fiorina';

  static TextStyle redHeading = TextStyle(
    color: AppColor.orangeHeadingColor,
    fontWeight: FontWeight.bold,
    fontSize: kIsWeb ? 35.h : 24.h,
    fontFamily: fiorinaFont,
  );

  static TextStyle blackHeading = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: kIsWeb ? 35.h : 24.h,
    fontFamily: fiorinaFont,
  );

  static TextStyle headingStyle = TextStyle(
    fontSize: 20.h,
    fontWeight: FontWeight.bold,
    fontFamily: 'NotoSans',
  );

  static TextStyle bookNameStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: kIsWeb ? 5.sp : 14.sp,
    fontFamily: 'NotoSans',
  );

  static TextStyle bookNameStyle770 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 5,
    fontFamily: 'NotoSans',
  );

  static TextStyle bookAuthorNameStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: kIsWeb ? 4.sp : 12.sp,
    fontFamily: 'NotoSans',
  );

  static TextStyle bookAuthorNameStyle770 = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 6.sp,
    fontFamily: 'NotoSans',
  );

  //Home Screen
  static const TextStyle boldText18 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle desktopBoldText18 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle mainHeading = TextStyle(fontSize: 27, fontWeight: FontWeight.bold);


  
}
