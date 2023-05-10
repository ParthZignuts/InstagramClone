import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/core/core.dart';
import '../../view.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
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

  /// when menu button  press then this method will be call
  onMneuPress(){
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 50,
                    decoration:  const BoxDecoration(color: primaryColor,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0,bottom: 8.0),
                    child: Text(
                      'Create',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: (){
                      AuthMethods().signOut();
                      Get.offAll(const LoginScreen());
                    },
                    leading:const Icon(Icons.logout,color: primaryColor,),
                    title: const Text('SignOut'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///to show bottomSheet that include option to upload socialMedia  activities
  showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 50,
                    decoration:  const BoxDecoration(color: primaryColor,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0,bottom: 8.0),
                    child: Text(
                      'Create',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () => (){},
                    leading: Image.asset('assets/images/reel.png', height: 30, color: primaryColor),
                    title: const Text('Reel'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Image.asset('assets/images/post.png', height: 30, color: primaryColor),
                    title: const Text('Post'),
                  ),
                ],
              ),
            ),
          );
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
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: mobileBackgroundColor,
                      expandedHeight: 325,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    userData['userName'],
                                    style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
                                  ),
                                  const Spacer(),
                                  IconButton(onPressed: () => showBottomSheet(), icon: const Icon(Icons.add_box_outlined)),
                                  IconButton(onPressed: () => onMneuPress(), icon: const Icon(Icons.menu)),
                                ],
                              ),
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

                              ///edit profile or share profile

                              Row(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                scrollDirection: Axis.vertical,
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
                            PersonalPostTab(
                              uid: widget.uid,
                              postLen: postLen,
                            ),
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
