import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String userName='parth_.11._';
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(userName,style: TextStyle(color: primaryColor),),
                ],
              ),
              const CircleAvatar(
                backgroundImage: NetworkImage(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
