
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/admin/db/admin_db_helper.dart';

import '../models/add_item_model.dart';

class AdminItemController extends GetxController{

  Future<bool> addNewItem(AddItemModel addItem,Uint8List imageSelectedByte){
    return AdminAPI.addNewItem(addItem, imageSelectedByte);
  }
}