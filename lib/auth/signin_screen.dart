import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebook_reader/services/providers/auth_provider.dart';
import 'package:ebook_reader/utils/constants.dart';
import 'package:ebook_reader/utils/responsive.dart';
import 'package:ebook_reader/widgets/global/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var appBarHeight = AppBar().preferredSize.height;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColor.mainBackgroundColor,
      appBar: AppConstants.customAppBar(context, false, "Sign in", false, true) as PreferredSizeWidget,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                height: Responsive.isDesktop(context) ? MediaQuery.of(context).size.height * 0.8 : null,
                width: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width * 0.6 : null,
                decoration: BoxDecoration(
                  image: Responsive.isDesktop(context)
                      ? DecorationImage(
                          image: const CachedNetworkImageProvider(
                            "https://i.pinimg.com/736x/0a/f0/b4/0af0b43b4c00b927496f7b8f28308f8f.jpg",
                          ),
                          opacity: 0.4,
                          fit: Responsive.isMobile(context) ? BoxFit.cover : BoxFit.fitHeight,
                        )
                      : null,
                  color: const Color.fromRGBO(254, 250, 238, 0.8),
                  border: Border.all(width: 1.5, color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 15, left: 15),
                      child: Container(
                        width: Responsive.isDesktop(context) ? 500 : null,
                        height: Responsive.isDesktop(context) ? MediaQuery.of(context).size.height * 0.6 : null,
                        decoration: BoxDecoration(
                            image: !Responsive.isDesktop(context)
                                ? DecorationImage(
                                    image: const CachedNetworkImageProvider(
                                      "https://i.pinimg.com/736x/0a/f0/b4/0af0b43b4c00b927496f7b8f28308f8f.jpg",
                                    ),
                                    opacity: 0.4,
                                    fit: Responsive.isMobile(context) ? BoxFit.cover : BoxFit.fitHeight,
                                  )
                                : null,
                            color: const Color.fromRGBO(237, 239, 238, 0.8),
                            border: Border.all(width: 1.5, color: Colors.grey.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40.h,
                              ),
                              const Text(
                                'Ebook Reader',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.blackColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Sign-in',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: emailController,
                                labelText: 'Enter your email',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                controller: passwordController,
                                labelText: 'Enter your password',
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.mainOrangeColor,
                                  minimumSize: Size(double.infinity, 50.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // Sign-in logic
                                  if (_formKey.currentState?.validate() ?? false) {
                                    auth.signIn(emailController.text, passwordController.text);
                                  }
                                },
                                child: const Text(
                                  'Sign-in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColor.lightGrey,
                                  ),
                                ),
                              ),
                              SizedBox(height: 50.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding:const  EdgeInsets.symmetric(
                        horizontal: 55,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.mainOrangeColor,
                          // minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Sign-in logic
                          if (_formKey.currentState?.validate() ?? false) {
                            auth.signIn(emailController.text, passwordController.text);
                          }
                        },
                        child: const Text(
                          'Continue as an author →',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.lightGrey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
