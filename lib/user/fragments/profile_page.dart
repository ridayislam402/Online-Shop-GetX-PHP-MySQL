import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/user/auth/login_page.dart';

import '../controllers/current_user_controller.dart';
import '../util/user_prefs.dart';

class ProfilePage extends StatelessWidget {
  final _currentUser = Get.put(CurrentUserController());


  signOutUser() async
  {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure?\nyou want to logout from app?",
        ),
        actions: [
          TextButton(
              onPressed: ()
              {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
          TextButton(
              onPressed: ()
              {
                Get.back(result: "loggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
        ],
      ),
    );

    if(resultResponse == "loggedOut")
    {
      //delete-remove the user data from phone local storage
      RememberUserPrefs.removeUserInfo()
          .then((value)
      {
        Get.off(LoginPage());
      });
    }
  }

  Widget userInfoItemProfile(IconData iconData, String userData)
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 16,),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('ccc ::${_currentUser.user.email}');
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
       /* Center(
          child: Image.asset(
            "images/man.png",
            width: 240,
          ),
        ),*/

        const SizedBox(height: 20,),

        userInfoItemProfile(Icons.person, _currentUser.user.name),

        const SizedBox(height: 20,),

        userInfoItemProfile(Icons.email, _currentUser.user.email),

        const SizedBox(height: 20,),
        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: ()
              {
                signOutUser();
              },
              borderRadius: BorderRadius.circular(32),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
