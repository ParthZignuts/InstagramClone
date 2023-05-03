import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/proiders/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/view/screens/login/login_screen.dart';
import 'package:instagram_clone/view/widget/widget.dart';
import 'package:provider/provider.dart';
import '../../../model/user.dart' as model;

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  /// when menu button  press then this method will be call
  onMenuPress(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Center(
            child: TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                child: const Text('Logout')),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Text(
                      user.userName,
                      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.add_box_outlined)),
                    IconButton(onPressed: () => onMenuPress(context), icon: const Icon(Icons.menu)),
                  ],
                ),
              ),
              const Divider(color: secondaryColor),

              ///Post, followers, following count
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  CircleAvatar(backgroundImage: NetworkImage(user.photoUrl), maxRadius: 40),
                  const PostFolloweFollowingStatus(title: 'Posts', values: '1756'),
                  const PostFolloweFollowingStatus(title: 'Followers', values: '2.2M'),
                  const PostFolloweFollowingStatus(title: 'Following', values: '2056'),
                ]),
              ),

              ///Bio
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '${user.bio}  \n........\n.......\n........\n........\n........',
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                ),
              ),

              ///edit profile or share profile

              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        height: 35,
                        decoration: BoxDecoration(
                          color: darkGray,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_reaction_outlined,
                            size: 20,
                          ),
                        )),
                  ],
                ),
              ),

              /// User stories
              Row(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 1,
                      child: const UserStoryStreamBuilder()),
                ],
              ),

              /// Tabs

              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          icon: Image.asset('assets/images/post.png', color: primaryColor, width: 24),
                        ),
                        Tab(
                          icon: Image.asset('assets/images/reel.png', color: primaryColor, width: 24),
                        ),
                        Tab(
                          icon: Image.asset('assets/images/tagpeople.png', color: primaryColor, width: 24),
                        ),
                      ],
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    const SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          PersonalPostTab(),
                          MyReelsTab(),
                          TagedMeTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
