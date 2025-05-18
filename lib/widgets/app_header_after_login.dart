import 'package:flutter/material.dart';
import 'app_styles.dart';

class AppHeaderAfterLogin extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderAfterLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.appGradient,
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.iconColor),
          title: const Text(
            "Flight Booking System",
            style: AppTextStyles.appBarTitle,
          ),
          centerTitle: true,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
