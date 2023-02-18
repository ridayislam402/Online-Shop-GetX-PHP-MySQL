import 'package:get/get.dart';

import '../db/db_helper.dart';
import '../models/user_model.dart';

class UserController extends GetxController{

  Future<bool> authenticate(String email) async{
  return API.authenticate(email);
  }

  Future<bool> registion(UserModel userModel) async{
    return API.registation(userModel);
  }

  Future<UserModel?> login(String email, String password) async{
    return API.newlogin(email, password);
  }

}