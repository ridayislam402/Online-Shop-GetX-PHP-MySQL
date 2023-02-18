import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class RememberUserPrefs{

 static Future<void> storeUserInfo(UserModel userInfo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toMap());
    await preferences.setString("currentUser", userJsonData);
  }
  
  static Future<UserModel?> readUserInfo() async{
   UserModel? currentUserInfo;
   SharedPreferences preferences = await SharedPreferences.getInstance();
   String? userinfo = preferences.getString("currentUser");

   if(userinfo != null){

     Map<String,dynamic> userDataMap = jsonDecode(userinfo);
     currentUserInfo = UserModel.fromJson(userDataMap);
   }
   return currentUserInfo;
  }

  static Future<void> removeUserInfo() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("currentUser");
  }
}