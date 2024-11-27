import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dev_mind/utils/local_storage/storage_utility.dart';
import 'package:dev_mind/features/authentication/screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index.toDouble());
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      TLocalStorage().saveData('isFirstTime', false);
      Get.offAll(() => const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Skip function
  void skipPage() {
    TLocalStorage().saveData('isFirstTime', false);
    Get.offAll(() => const LoginScreen());
  }
}