import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/user/fragments/favorites_page.dart';
import 'package:online_shopping_getx_mysql_php/user/fragments/home_page.dart';
import 'package:online_shopping_getx_mysql_php/user/fragments/order_page.dart';
import 'package:online_shopping_getx_mysql_php/user/fragments/profile_page.dart';

import '../controllers/current_user_controller.dart';


class DashbordPage extends StatelessWidget {
  final _rememberCurrentUser = Get.put(CurrentUserController());

  List _pageList = [
    HomePage(),
    FavoritePage(),
    OrderPage(),
    ProfilePage()
  ];
  List _navigationBottomsPropertis = [
    {
      'active_icon' : Icons.home,
      'non_active_icon' : Icons.home_outlined,
      'label' : 'Home'
    },
    {
      'active_icon' : Icons.favorite,
      'non_active_icon' : Icons.favorite_border,
      'label' : 'Favorites'
    },
    {
      'active_icon' : FontAwesomeIcons.boxOpen,
      'non_active_icon' : FontAwesomeIcons.box,
      'label' : 'Order'
    },
    {
      'active_icon' : Icons.person,
      'non_active_icon' : Icons.person_outlined,
      'label' : 'Profile'
    }
  ];
  RxInt _indexNumber = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Obx(() => _pageList[_indexNumber.value])),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            currentIndex: _indexNumber.value,
            onTap: (value) {
                _indexNumber.value = value;
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.white24,
            items: List.generate(4, (index) {
              final navBtnPropary = _navigationBottomsPropertis[index];
              return BottomNavigationBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(navBtnPropary['non_active_icon']),
                  activeIcon: Icon(navBtnPropary['active_icon']),
                  label: navBtnPropary['label'],
              );
            }),

        ),
      ),
    );
  }
}
