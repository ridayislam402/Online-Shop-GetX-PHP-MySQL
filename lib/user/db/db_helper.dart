import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/get_item_model.dart';
import '../models/user_model.dart';
class API{
  //users
  static const hostConnection = "https://ecommerceprojectriday.000webhostapp.com/shopping";
  static const login = "$hostConnection/user/login.php";
  static const signup = "$hostConnection/user/signup.php";
  static const validateEmail = "$hostConnection/user/validate_email.php";
  static const trending = "$hostConnection/user/trending.php";
  static const productItemImage = "$hostConnection/item_image/";





  static Future<bool> authenticate(email) async{
    dynamic resBody;
      print('ok1');
      final res = await http.post(
          Uri.parse(API.validateEmail),
          body: {'email': email}
      );
      if(res.statusCode == 200){
        resBody = jsonDecode(res.body);
      }
      if(resBody['emailFound'] == true){
        return false;
      }else{
        return true;
      }
  }

  static Future<bool> registation(UserModel userModel) async{
    dynamic signupjsonBody;
    final res = await http.post(Uri.parse(API.signup),
        body: userModel.toMap()
    );
    if(res.statusCode == 200){
      signupjsonBody = jsonDecode(res.body);
    }
    if(signupjsonBody['success'] == true){
      return true;
    }else{
      return false;
    }
  }

  static Future<UserModel?> newlogin(String email,String password) async{
    dynamic resBodyOfLogin;
    final res = await http.post(Uri.parse(API.login),
        body: {
            'email' : email,
            'password' : password
        }
    );
    if(res.statusCode == 200){
      resBodyOfLogin = jsonDecode(res.body);
    }
    if(resBodyOfLogin['success'] == true){
     final user = UserModel.fromJson(resBodyOfLogin["userData"]);
      return user;
    }
  }

  static Future<List<GetItemModel>> trendingItem()async{
    List<GetItemModel> trendingClothItemsList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.trending)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfTrending = jsonDecode(res.body);
        if(responseBodyOfTrending["success"] == true)
        {
          (responseBodyOfTrending["clothItemsData"] as List).forEach((eachRecord)
          {
            trendingClothItemsList.add(GetItemModel.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }
    return trendingClothItemsList;

  }

}