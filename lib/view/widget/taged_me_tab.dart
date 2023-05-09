import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class TagedMeTab extends StatelessWidget {
  const TagedMeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/nophotosuploaded.json',
            ),
            const Text(
              'No post yet',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ));
  }
}
