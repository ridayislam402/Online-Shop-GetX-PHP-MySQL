import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/admin/pages/admin_login_page.dart';
import 'package:online_shopping_getx_mysql_php/user/auth/signup_page.dart';
import 'package:online_shopping_getx_mysql_php/user/fragments/dashbord_page.dart';

import '../controllers/user_controller.dart';
import '../util/user_prefs.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = Get.put(UserController());
  var formKey= GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  var isObsecure = true.obs;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
     // appBar: AppBar(title: Text('Login page'),),
      body: LayoutBuilder(
          builder: (context, con) {
          return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: con.maxHeight,
              ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child: Image.asset("images/login.jpg"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(Radius.circular(60)
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0,-3),
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30,30,30,8),
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      validator: (value) => value == "" ? "Please write email" : null,
                                      decoration:  InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide:  BorderSide(
                                              color: Colors.white60
                                            )
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide:  BorderSide(
                                                  color: Colors.white60
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide:  BorderSide(
                                                  color: Colors.white60
                                              )
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              borderSide:  BorderSide(
                                                  color: Colors.white60
                                              )
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                          fillColor: Colors.white,
                                          hintText: 'Email ....',
                                          prefixIcon: const Icon(Icons.email,color: Colors.black,),
                                          filled: true),
                                    ),
                                    const SizedBox(height: 18,),
                                    Obx(
                                      () => TextFormField(
                                        controller: passController,
                                        obscureText: isObsecure.value,
                                        validator: (value) => value == "" ? "Please write password" : null,
                                        decoration:  InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide:  BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide:  BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide:  BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide:  BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                            suffixIcon: Obx(() => GestureDetector(
                                              onTap: () {
                                                isObsecure.value = ! isObsecure.value;
                                              },
                                              child: Icon(
                                                isObsecure.value? Icons.visibility_off : Icons.visibility,
                                              ),
                                            )),
                                            fillColor: Colors.white,
                                            hintText: 'password ....',
                                            prefixIcon: Icon(Icons.vpn_key_sharp,color: Colors.black,),
                                            filled: true),
                                      ),
                                    ),
                                    const SizedBox(height: 18,),
                                    Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: authenticate,
                                        borderRadius: BorderRadius.circular(30),
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                                            child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 16),),
                                        ),


                                      ),
                                    )
                                  ],
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an Account?",style: TextStyle(color: Colors.white),),
                                TextButton(
                                    onPressed: () {
                                      Get.to(SignupPage());
                                    },
                                    child: Text('SignUp Here',))
                              ],
                            ),
                            Text('Or'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Are you an Admin?",style: TextStyle(color: Colors.white),),
                                TextButton(
                                    onPressed: () {
                                      Get.to(AdminLoginPage());
                                    },
                                    child: Text('Click Here',))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
          },),
    );
  }

  void authenticate() {
    if(formKey.currentState!.validate()){
      userController.login(emailController.text.trim(), passController.text.trim()).then((value)async {
        if(value != null){
          await RememberUserPrefs.storeUserInfo(value);
          print('ok');
          Get.to(DashbordPage());
        }else{
          Fluttertoast.showToast(msg: "Please enter currect user & password");
        }

       /* if(value){
          Fluttertoast.showToast(msg: 'Login Success');
          print('login');
        }else{
          Fluttertoast.showToast(msg: 'Login not Success');
          print('not login');

        }*/
      });
    }
  }
}
