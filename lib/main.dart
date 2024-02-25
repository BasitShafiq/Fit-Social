import 'package:fitsocial/charts_screen.dart';
import 'package:fitsocial/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:fitsocial/bindings/initial_binding.dart';
import 'package:fitsocial/config/Themes/mainThemeFile.dart';
import 'package:fitsocial/config/initial_main_methods/initial_main_methods.dart';
import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      defaultTransition: Transition.fade,
      theme: MainTheme(context).themeData,
      debugShowCheckedModeBanner: false,
      getPages: Routes.pages,
      initialRoute: "/",
    );
  }
}
