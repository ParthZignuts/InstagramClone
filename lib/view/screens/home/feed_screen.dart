import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widget/widget.dart';
import 'package:instagram_clone/utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/ic_instagram.svg',
                    color: primaryColor,
                  ),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    UserStory(),
                    PostCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
