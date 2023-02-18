import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_shopping_getx_mysql_php/admin/amin_controller/admin_item_controller.dart';
import 'package:online_shopping_getx_mysql_php/admin/models/add_item_model.dart';
import 'package:online_shopping_getx_mysql_php/admin/pages/admin_login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../user/util/constants.dart';
import '../db/admin_db_helper.dart';


class AdminUploadItems extends StatefulWidget
{


  @override
  State<AdminUploadItems> createState() => _AdminUploadItemsState();
}





class _AdminUploadItemsState extends State<AdminUploadItems>
{
  final itemController =Get.put(AdminItemController());
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";


  //defaultScreen methods
  captureImageWithPhoneCamera() async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();

    setState(()=> pickedImageXFile);
    if(pickedImageXFile != null)
    {
      final bytesOfImage = await pickedImageXFile!.readAsBytes();

      setSelectedImage(bytesOfImage);
     // setSelectedImageName(path.basename(pickedImageXFile!.path));
    }
  }

  setSelectedImage(Uint8List selectedImage)
  {
    _imageSelectedByte.value = selectedImage;
  }

  pickImageFromPhoneGallery() async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    Get.back();

    setState(()=> pickedImageXFile);

    if(pickedImageXFile != null)
    {
      final bytesOfImage = await pickedImageXFile!.readAsBytes();

      setSelectedImage(bytesOfImage);
     // setSelectedImageName(path.basename(pickedImageXFile.path));
    }
  }



  showDialogBoxForImagePickingAndCapturing()
  {
    return showDialog(
      context: context,
      builder: (context)
      {
        return SimpleDialog(
          backgroundColor: Colors.black,
          title: const Text(
            "Item Image",
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: ()
              {
                captureImageWithPhoneCamera();
              },
              child: const Text(
                "Capture with Phone Camera",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: ()
              {
                pickImageFromPhoneGallery();
              },
              child: const Text(
                "Pick Image From Phone Gallery",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: ()
              {
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      }
    );
  }
  //defaultScreen methods ends here



  // upload image in mysql
  uploadItemImage()async{
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizesList = sizesController.text.split(',');
    List<String> colorsList = colorsController.text.split(',');

    if(formKey.currentState!.validate())
    {
      EasyLoading.show(status: 'please wait ...');
    }
    final addItem = AddItemModel(
        item_id : 1,
        name : nameController.text.trim(),
        rating : ratingController.text.trim(),
        tags : tagsList.toString(),
        price : priceController.text.trim(),
        sizes : sizesList.toString(),
        colors : colorsList.toString(),
        description : descriptionController.text.trim(),
        image : nameController.text.trim()+ "-" +DateTime.now().millisecondsSinceEpoch.toString(),
    );
    
    try
    {
      itemController.addNewItem(addItem, imageSelectedByte).then((value) {
        if(value == true){
          Fluttertoast.showToast(msg: "Successfully uploaded");
          setState(() {
            pickedImageXFile = null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            sizesController.clear();
            colorsController.clear();
            descriptionController.clear();
          });
          EasyLoading.dismiss();
          Get.to(AdminUploadItems());
        }
      });
    }
    catch(erroeMsg)
    {
      Fluttertoast.showToast(msg: "Error: " + erroeMsg.toString());
    }
  }

  // upload image in third party api
 /* uploadItemImage() async
  {
    var requestImgurApi = http.MultipartRequest(
        "POST",
        Uri.parse("https://fakestoreapi.com/products")
        //Uri.parse("ttps://photoslibrary.googleapis.com/v1/uploads")

    );
print('ok2');
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
   // requestImgurApi.headers['Authorization'] = "Client-ID " + "6ca0d6456311e4d";
    print('ok3');

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );
    print('ok4');

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();
    print('ok5');

    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);
    print('ok6 : $resultFromImgurApi');

   *//* Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();
    print(resultFromImgurApi);*//*
  }*/


  @override
  Widget build(BuildContext context)
  {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
  Widget defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                appBarColor,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
            "Welcome Admin"
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white54,
                size: 200,
              ),

              //button
              Material(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: ()
                  {
                    showDialogBoxForImagePickingAndCapturing();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child: Text(
                      "Add New Item",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadItemFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.deepPurple,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
            "Upload Form"
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: ()
          {
            Get.to(AdminLoginPage());
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()
            {
              uploadItemImage();
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [

          //image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //upload item form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(
                  Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [

                    //email-password-login button
                    Form(
                      key: formKey,
                      child: Column(
                        children: [

                          //item name
                          TextFormField(
                            controller: nameController,
                            validator: (val) => val == "" ? "Please write item name" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "item name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //item ratings
                          TextFormField(
                            controller: ratingController,
                            validator: (val) => val == "" ? "Please give item rating" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.rate_review,
                                color: Colors.black,
                              ),
                              hintText: "item rating...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //item tags
                          TextFormField(
                            controller: tagsController,
                            validator: (val) => val == "" ? "Please write item tags" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "item tags...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //item price
                          TextFormField(
                            controller: priceController,
                            validator: (val) => val == "" ? "Please write item price" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change_outlined,
                                color: Colors.black,
                              ),
                              hintText: "item price...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //item sizes
                          TextFormField(
                            controller: sizesController,
                            validator: (val) => val == "" ? "Please write item sizes" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.picture_in_picture,
                                color: Colors.black,
                              ),
                              hintText: "item size...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //item colors
                          TextFormField(
                            controller: colorsController,
                            validator: (val) => val == "" ? "Please write item colors" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.color_lens,
                                color: Colors.black,
                              ),
                              hintText: "item colors...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //item description
                          TextFormField(
                            controller: descriptionController,
                            validator: (val) => val == "" ? "Please write item description" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              hintText: "item description...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //button
                          Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: ()
                              {
                                uploadItemImage();
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "Upload Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16,),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
