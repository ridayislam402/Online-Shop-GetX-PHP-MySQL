import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/user/auth/login_page.dart';
import 'package:online_shopping_getx_mysql_php/user/fragments/dashbord_page.dart';
import 'package:online_shopping_getx_mysql_php/user/models/user_model.dart';
import 'package:online_shopping_getx_mysql_php/user/util/user_prefs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Online Shopping GetX',
      debugShowCheckedModeBanner:false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<UserModel?>(
          future: RememberUserPrefs.readUserInfo(),
          builder: (context, snapshot) {
            print('dd :: ${snapshot.data}');
            //final data = RememberUserPrefs.readUserInfo();
            if(snapshot.data == null){
              return LoginPage();
            }else{
              return DashbordPage();
            }
          },
      ),
    );
  }
}
