import 'dart:typed_data';

import 'package:get/get.dart';

class AddPostController extends GetxController {
  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }
}
