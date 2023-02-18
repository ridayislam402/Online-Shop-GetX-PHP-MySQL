import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/user/db/db_helper.dart';

import '../models/get_item_model.dart';

class ProductItemController extends GetxController{
  Future<List<GetItemModel>> getTrendingItem(){
    return API.trendingItem();
  }
}