import 'package:get/get.dart';
import '../models/user_model.dart';
import '../util/user_prefs.dart';

class CurrentUserController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Rx<UserModel> _currentUser = UserModel(0, '', '', '').obs;
  UserModel get user => _currentUser.value;


  getUserInfo() async{
    final getUserInfoFromLocalStorage =await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }

}