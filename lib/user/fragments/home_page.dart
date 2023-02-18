
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/user/controllers/product_item_controller.dart';
import 'package:online_shopping_getx_mysql_php/user/db/db_helper.dart';

import '../models/get_item_model.dart';
import '../util/constants.dart';


class HomePage extends StatelessWidget
{
  final productItemController = Get.put(ProductItemController());
  TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 16,),

          //search bar widget
          showSearchBarWidget(),

          const SizedBox(height: 24,),

          //trending-popular items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Trending",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),

          trendingMostPopularClothItemWidget(context),


          const SizedBox(height: 24,),

          //all new collections/items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "New Collections",
              style: TextStyle(
                color: appBarColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget showSearchBarWidget()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {

            },
            icon: const Icon(
              Icons.search,
              color: appBarColor,
            ),
          ),
          hintText: "Search best clothes here...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: ()
            {

            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.red,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: appBarColor,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.green,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }

 Widget trendingMostPopularClothItemWidget(BuildContext context) {
   return FutureBuilder(
     future: productItemController.getTrendingItem(),
     builder: (context, AsyncSnapshot<List<GetItemModel>> dataSnapShot)
     {
       if(dataSnapShot.connectionState == ConnectionState.waiting)
       {
         return const Center(
           child: CircularProgressIndicator(),
         );
       }
       if(dataSnapShot.data == null)
       {
         return const Center(
           child: Text(
             "No Trending item found",
           ),
         );
       }
       if(dataSnapShot.data!.length > 0)
       {
         return SizedBox(
           height: 260,
           child: ListView.builder(
             itemCount: dataSnapShot.data!.length,
             scrollDirection: Axis.horizontal,
             itemBuilder: (context, index)
             {
               GetItemModel eachClothItemData = dataSnapShot.data![index];
               return GestureDetector(
                 onTap: ()
                 {

                 },
                 child: Container(
                   width: 200,
                   margin: EdgeInsets.fromLTRB(
                     index == 0 ? 16 : 8,
                     10,
                     index == dataSnapShot.data!.length - 1 ? 16 : 8,
                     10,
                   ),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Colors.black,
                     boxShadow:
                     const [
                       BoxShadow(
                         offset: Offset(0,3),
                         blurRadius: 6,
                         color: Colors.grey,
                       ),
                     ],
                   ),
                   child: Column(
                     children: [

                       //item image
                       ClipRRect(
                         borderRadius: const BorderRadius.only(
                           topLeft: Radius.circular(22),
                           topRight: Radius.circular(22),
                         ),
                         child: FadeInImage(
                           height: 150,
                           width: 200,
                           fit: BoxFit.cover,
                           placeholder: const AssetImage("images/placeholder.png"),
                           image: NetworkImage(
                              API.productItemImage + eachClothItemData.image!,
                           ),
                           imageErrorBuilder: (context, error, stackTraceError)
                           {
                             return const Center(
                               child: Icon(
                                 Icons.broken_image_outlined,
                               ),
                             );
                           },
                         ),
                       ),

                       //item name & price
                       //rating stars & rating numbers
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [

                             //item name & price
                             Row(
                               children: [
                                 Expanded(
                                   child: Text(
                                     eachClothItemData.name!,
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                     style: const TextStyle(
                                       color: Colors.grey,
                                       fontSize: 16,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                                 const SizedBox(
                                   width: 10,
                                 ),
                                 Text(
                                   eachClothItemData.price.toString(),
                                   style: const TextStyle(
                                     color: Colors.white,
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ],
                             ),

                             const SizedBox(height: 8,),

                             //rating stars & rating numbers
                             Row(
                               children: [

                                 RatingBar.builder(
                                   initialRating: eachClothItemData.rating!,
                                   minRating: 1,
                                   direction: Axis.horizontal,
                                   allowHalfRating: true,
                                   itemCount: 5,
                                   itemBuilder: (context, c)=> const Icon(
                                     Icons.star,
                                     color: Colors.amber,
                                   ),
                                   onRatingUpdate: (updateRating){},
                                   ignoreGestures: true,
                                   unratedColor: Colors.grey,
                                   itemSize: 20,
                                 ),

                                 const SizedBox(width: 8,),

                                 Text(
                                   "(" + eachClothItemData.rating.toString() + ")",
                                   style: const TextStyle(
                                     color: Colors.grey,
                                   ),
                                 ),

                               ],
                             ),

                           ],
                         ),
                       ),

                     ],
                   ),
                   
                 ),
               );
             },
           ),
         );
       }
       else
       {
         return const Center(
           child: Text("Empty, No Data."),
         );
       }
     },
   );
 }
}
