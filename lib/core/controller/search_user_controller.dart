import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchUserController extends GetxController {
  final Rx<TextEditingController> searchController = TextEditingController().obs;
  var isShowUsers = false.obs;
  var isFollowing = false.obs;
  var isLoading = false.obs;
  var uid = ''.obs;
  var userData = {}.obs;
  var postLen = 0.obs;
  var followers = 0.obs;
  var following = 0.obs;

  void updateSearchControllerValues(String value) {
    searchController.value.text = value;
  }

  ///used to show searched users
  void setIsShowUser(bool values) {
    isShowUsers.value = values;
  }

  ///it's used to set the loading values if some data will be loading then it's true otherwise it's false
  void setLoadingValues(bool values) {
    isLoading.value = values;
  }

  void checkWhetherIsFollowing(bool values) {
    isFollowing.value = values;
  }

  void updateUserData(dynamic values) {
    userData.value = values;
  }

  void updatePostLen(int values) {
    postLen.value = values;
  }

  void updateFollowers(int values) {
    followers.value = values;
  }

  void updateFollowing(int values) {
    following.value = values;
  }
}
