import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
const kPrimaryColor = Color(0xFF17487D);

const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
const COLOR_GREY = Color.fromRGBO(141, 141, 141, 1.0);
// const Color COLOR_ACCENT = Color(0xffFCAAAB);
Color? COLOR_ACCENT = Colors.blue[200];
const COLOR_WHITE = Colors.white;
const COLOR_DARK_BLUE = Color.fromRGBO(20, 25, 45, 1.0);

 TextTheme TEXT_THEME_DEFAULT = TextTheme(
    headline1: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 26.sp),
    headline2: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22.sp),
    headline3: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20.sp),
    headline4: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 16.sp),
    headline5: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14.sp),
    headline6: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12.sp),
    bodyText1: TextStyle(
        color: COLOR_BLACK, fontSize: 14.sp, fontWeight: FontWeight.w500,height: 1.5.h),
    bodyText2: TextStyle(
        color:  COLOR_GREY, fontSize: 14.sp, fontWeight: FontWeight.w500,height: 1.5.h),
    subtitle1:
    TextStyle(color: COLOR_BLACK, fontSize: 12.sp, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 12.sp, fontWeight: FontWeight.w400));

 TextTheme TEXT_THEME_SMALL = TextTheme(
    headline1: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22.sp),
    headline2: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20.sp),
    headline3: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 18.sp),
    headline4: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14.sp),
    headline5: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12.sp),
    headline6: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 10.sp),
    bodyText1: TextStyle(
        color: COLOR_BLACK, fontSize: 12.sp, fontWeight: FontWeight.w500,height: 1.5.h),
    bodyText2: TextStyle(
        color:  COLOR_GREY, fontSize: 12.sp, fontWeight: FontWeight.w500,height: 1.5.h),
    subtitle1:
    TextStyle(color: COLOR_BLACK, fontSize: 10.sp, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 10.sp, fontWeight: FontWeight.w400));
