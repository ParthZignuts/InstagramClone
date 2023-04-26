import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/proiders/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/view/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/view/responsive/responsive_layout.dart';
import 'package:instagram_clone/view/responsive/web_screen_layout.dart';
import 'package:instagram_clone/view/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAwgLy72bfxyOAtPQSomBJi_z0coDhBha4",
            appId: "1:115403219546:web:c9eebe75863d9127f96e63",
            messagingSenderId: "115403219546",
            storageBucket: "instagram-clone-2701d.appspot.com",
            projectId: "instagram-clone-2701d"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
