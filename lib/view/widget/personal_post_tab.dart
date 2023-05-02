import 'package:flutter/material.dart';

class PersonalPostTab extends StatelessWidget {
  const PersonalPostTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (_, index) =>  Padding(
        padding: const EdgeInsets.all(1.0),
        child: Image.network('https://picsum.photos/250?image=$index'),
      ),
      itemCount: 50,
    );
  }
}
