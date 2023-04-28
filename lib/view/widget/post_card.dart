import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.snap,
    super.key,
  });

  final snap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(snap['profImage']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snap['username'],
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      'Gandhinagar Gujrat',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
        ),
        Image.network(snap['photoUrl'], fit: BoxFit.fill),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.bubble_right)),
            Transform.rotate(
              angle: 610 * pi / 330,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                    )),
              ),
            ),
            const Spacer(),
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.bookmark)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${snap['likes'].length} likes',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: [
                    Text(
                      '${snap['username']}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '${snap['caption']}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                style: const TextStyle(fontWeight: FontWeight.w400, color: secondaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
