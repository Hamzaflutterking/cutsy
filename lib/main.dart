import 'package:cutcy/auth/splash_screen.dart';
import 'package:cutcy/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.05)),
          child: GetMaterialApp(
            transitionDuration: Duration(milliseconds: 600),
            defaultTransition: Transition.fadeIn,
            debugShowCheckedModeBanner: false,
            title: 'Cutsy',
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'SFProDisplay',
              appBarTheme: AppBarTheme(color: white, elevation: 0, centerTitle: true, scrolledUnderElevation: 0),
              bottomAppBarTheme: BottomAppBarTheme(elevation: 0, color: white, height: 120.h),
              hintColor: grey,
              colorScheme: ColorScheme.fromSeed(seedColor: white),
            ),
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
