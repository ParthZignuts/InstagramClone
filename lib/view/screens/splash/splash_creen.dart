import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import '../../screens/screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///fetch current user's photo to show in bottomNavigationBar
  Future<void> fetchData() async {
    try {
      // Fetch the current user's data from Firebase Auth and Firestore
      Future.delayed(const Duration(seconds: 3), () {
        AuthMethods().getUserDetail();
        // Navigate to the next screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(child: Image.asset('assets/images/instalogo.png', alignment: Alignment.center, height: 120)),
          const Spacer(),
           Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [purpleLinear1,purpleLinear2,purpleLinear3],
                  ).createShader(bounds);
                },
                child: const Text(
              'Instagram',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.pinkAccent),
            )),
          ),
        ],
      ),
    );
  }
}
