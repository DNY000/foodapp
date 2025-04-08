import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:foodapp/common/color_extension.dart';
import 'package:foodapp/routes/page_router.dart'; // Import router
import 'package:foodapp/ultils/local_storage/storage_utilly.dart';
import 'package:foodapp/view/authentication/viewmodel/login_viewmodel.dart';
import 'package:foodapp/view/authentication/viewmodel/signup_viewmodel.dart';
import 'package:foodapp/viewmodels/favorite_viewmodel.dart';
import 'package:foodapp/viewmodels/order_viewmodel.dart';
import 'package:foodapp/viewmodels/restaurant_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/viewmodels/food_viewmodel.dart';
import 'package:foodapp/viewmodels/category_viewmodel.dart';
import 'package:foodapp/viewmodels/home_viewmodel.dart';
import 'package:foodapp/viewmodels/user_viewmodel.dart';

import 'package:foodapp/core/firebase_options.dart'
    if (kIsWeb) 'package:foodapp/core/firebase_web_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Khởi tạo local storage trước khi khởi động ứng dụng
  await TLocalStorage.init('food_app');

  // Khởi tạo Firebase với xử lý riêng cho web
  await Firebase.initializeApp(
    options: kIsWeb
        ? FirebaseOptions(
            apiKey: dotenv.env["API_KEY"] ?? "",
            authDomain: "foodapp-daade.firebaseapp.com",
            projectId: "foodapp-daade",
            storageBucket: "foodapp-daade.appspot.com",
            messagingSenderId: "44206956684",
            appId: dotenv.env['APP_ID'] ?? "",
            measurementId: "G-ZCRF80FGZ6")
        : DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => RestaurantViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => FavoriteViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: ThemeData(
        primaryColor: TColor.primary,
        fontFamily: "Quicksand",
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: TColor.primary),
        ),
      ),
    );
  }
}
