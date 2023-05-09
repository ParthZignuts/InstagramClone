import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/resources/auth_methods.dart';
import '../../../core/resources/firestore_methods.dart';
import '../../../view/view.dart';

class SearchedUserProfileScreen extends StatefulWidget {
  final String uid;

  const SearchedUserProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<SearchedUserProfileScreen> createState() => _SearchedUserProfileScreenState();
}

class _SearchedUserProfileScreenState extends State<SearchedUserProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isRequested = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      // get post length
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackbar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SafeArea(
              child: NestedScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: mobileBackgroundColor,
                      expandedHeight: 352,
                      centerTitle: false,
                      title: Text(
                        userData['userName'],
                        style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      actions: [
                        IconButton(onPressed: () => () {}, icon: const Icon(Icons.menu)),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.only(top: 55.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(color: secondaryColor),

                                ///Post, followers, following count
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    CircleAvatar(backgroundImage: NetworkImage(userData['photoUrl']), maxRadius: 40),
                                    PostFolloweFollowingStatus(title: 'Posts', values: postLen),
                                    PostFolloweFollowingStatus(title: 'Followers', values: followers),
                                    PostFolloweFollowingStatus(title: 'Following', values: following),
                                  ]),
                                ),

                                ///Bio
                                Text(
                                  '${userData['bio']}  \n........\n.......\n........\n........\n........',
                                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                                ),
                                Row(
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor: mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => const LoginScreen(),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await FireStoreMethods().followUser(
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FireStoreMethods().followUser(
                                                    FirebaseAuth.instance.currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: DefaultTabController(
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
                      Expanded(
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            PersonalPostTab(uid: widget.uid, postLen: postLen),
                            const MyReelsTab(),
                            const TagedMeTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
