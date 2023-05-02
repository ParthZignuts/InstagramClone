import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/view/screens/screens.dart';
import '../../model/user.dart' as model;
import '../../resources/auth_methods.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int _page = 0;
  String _photoUrl='';
  void getCurrentUserDetails() async {
    model.User? currentUser = await AuthMethods().getUserDetail();
    setState(() {
      _photoUrl = currentUser.photoUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getCurrentUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) => onPageChanged(value),
        controller: pageController,
        children:  const [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          NotificationScreen(),
          PersonalScreen(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: _page == 2 ? primaryColor : secondaryColor),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: _page == 3 ? primaryColor : secondaryColor),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(backgroundImage: NetworkImage(_photoUrl),radius: 16),
            backgroundColor: primaryColor,
          ),
        ],
        backgroundColor: Colors.transparent,
        onTap: navigationTapped,
      ),
    );
  }
}
