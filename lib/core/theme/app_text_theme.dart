import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
  }) {
    return GoogleFonts.soraTextTheme(
      TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
          color: primary,
        ),

        headlineMedium: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w600,
          color: primary,
        ),

        titleLarge: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: primary,
        ),

        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: primary,
          height: 1.5,
        ),

        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: primary,
          height: 1.5,
        ),

        bodySmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: secondary,
        ),

        labelLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),
    );
  }
}
