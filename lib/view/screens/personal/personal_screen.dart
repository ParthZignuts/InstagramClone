
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/view/widget/widget.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String userName = 'jenny_111';
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  const Text(
                    userName,
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_outlined)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                ],
              ),
            ),
            const Divider(color: secondaryColor),

            ///Post, followers, following count
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                CircleAvatar(backgroundImage: AssetImage('assets/images/user.png'), maxRadius: 40),
                PostFolloweFollowingStatus(title: 'Posts', values: '1756'),
                PostFolloweFollowingStatus(title: 'Followers', values: '2.2M'),
                PostFolloweFollowingStatus(title: 'Following', values: '2056'),
              ]),
            ),

            ///Bio
            const Text(
              'Travelling Lover\n ........ \n .........\n .........',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
            ),

            ///edit profile or share profile

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EditShareProfileButton(
                  onPressed: () {},
                  btnTitle: 'Edit Profile',
                ),
                EditShareProfileButton(
                  onPressed: () {},
                  btnTitle: 'Share Profile',
                ),
                Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: darkGray,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_reaction_outlined),
                    )),
              ],
            ),

            /// User stories
            const UserStoryStreamBuilder(),

            /// Tabs

          ],
        ),
      ),
    );
  }
}