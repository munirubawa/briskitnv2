import 'dart:ui';
import 'dart:io' show Platform;

import 'package:briskitnv/Screens/mainScreen.dart';
import 'package:briskitnv/controller_bindings.dart';
import 'package:briskitnv/theme_constants.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'globals.dart';

 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCXqxvmr-r_ycUAtLCqrTztFZksfhLmCbo',
      appId: '1:677336048242:android:a4c0e8e96135526b7098eb',
      messagingSenderId: '677336048242',
      projectId: 'brisketnv',
      storageBucket: 'brisketnv.appspot.com',
    ),
  );


  await GetStorage.init();
  setWidowSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double screenWidth = window.physicalSize.width;
    return ScreenUtilInit(
        designSize: const Size(360, 690),

        builder: () {
      return GetMaterialApp(

        defaultTransition: Transition.rightToLeftWithFade,
        title: 'Login',
        initialBinding: ControllerBindings(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: COLOR_WHITE,
            // textTheme: screenWidth < 500 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT,
            fontFamily: "Montserrat",
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: COLOR_DARK_BLUE)),
        home: const MainScreen(),
        builder: (context, widget) {
          themeData = Theme.of(context);
          ScreenUtil.setContext(context);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
      );
    });
  }
}

Future<void> setWidowSize() async {
  if (Platform.isAndroid || Platform.isIOS)  return;

  await DesktopWindow.setMinWindowSize(const Size(1200, 800));
}
