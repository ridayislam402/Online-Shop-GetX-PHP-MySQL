import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:online_shopping_getx_mysql_php/admin/models/add_item_model.dart';
import 'package:online_shopping_getx_mysql_php/admin/models/admin_model.dart';
class AdminAPI{

  static const hostConnection = "https://ecommerceprojectriday.000webhostapp.com/shopping";
  static const adminLogin = "$hostConnection/admin/login.php";
  static const addItem = "$hostConnection/admin/add_items.php";



  static Future<AdminModel?> newadminlogin(String email,String password) async{
    dynamic resBodyOfLogin;
    final res = await http.post(Uri.parse(AdminAPI.adminLogin),
        body: {
          'email' : email,
          'password' : password
        }
    );
    if(res.statusCode == 200){
      resBodyOfLogin = jsonDecode(res.body);
    }
    if(resBodyOfLogin['success'] == true){
      final user = AdminModel.fromJson(resBodyOfLogin["userData"]);
      return user;
    }
  }

  static Future<bool> addNewItem(AddItemModel addItem,Uint8List imageSelectedByte) async{
    var responseBodyOfAddNewOrder;
    var res = await http.post(
      Uri.parse(AdminAPI.addItem),
      body: addItem.toJson(base64Encode(imageSelectedByte)),
    );
    if (res.statusCode == 200)
    {
      responseBodyOfAddNewOrder = jsonDecode(res.body);
    }
    if(responseBodyOfAddNewOrder["success"] == true)
    {
      // EasyLoading.dismiss();
      return true;
    }else{
      return false;
    }
  }

}