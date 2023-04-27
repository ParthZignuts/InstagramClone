import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'jenny_111',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Text(
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
            Image.network(
                'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60'),
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
            const Text(
              '12,566 likes',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
              child: Text(
                'Life Is A One Time Offer,Use It Well 🤙💛',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            const Text(
              '1 hour ago',
              style: TextStyle(fontWeight: FontWeight.w400, color: secondaryColor),
            ),
          ],
        );
      },
    );
  }
}
