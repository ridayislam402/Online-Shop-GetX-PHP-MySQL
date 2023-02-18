import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/admin/models/admin_model.dart';

import '../../user/db/db_helper.dart';
import '../db/admin_db_helper.dart';


class UserController extends GetxController{


  Future<AdminModel?> login(String email, String password) async{
    return AdminAPI.newadminlogin(email, password);
  }

}