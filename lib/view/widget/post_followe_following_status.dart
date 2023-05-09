
import 'package:flutter/material.dart';

class PostFolloweFollowingStatus extends StatelessWidget {
  const PostFolloweFollowingStatus({
    required this.title,
    required this.values,
    super.key,
  });

  final int values;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          values.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
        ),
      ],
    );
  }
}