import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_shopping_getx_mysql_php/user/auth/login_page.dart';
import 'package:http/http.dart' as http;

import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var userController = Get.put(UserController());
  var formKey= GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  var isObsecure = true.obs;

  @override
  void dispose() {
    nameController.dispose();
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
                    child: Image.asset("images/register.jpg"),
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
                                      controller: nameController,
                                      validator: (value) => value == "" ? "Please write name" : null,
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
                                          hintText: 'Name ....',
                                          prefixIcon: const Icon(Icons.person,color: Colors.black,),
                                          filled: true),
                                    ),
                                    const SizedBox(height: 18,),
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
                                          onTap: authenticateReg,
                                          borderRadius: BorderRadius.circular(30),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                                            child: Text('SignUp',style: TextStyle(color: Colors.white,fontSize: 16),),
                                          ),
                                        ),
                                      ),

                                  ],
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an Account?",style: TextStyle(color: Colors.white),),
                                TextButton(
                                    onPressed: () {
                                      Get.to(LoginPage());

                                    },
                                    child: Text('Login Here',))
                              ],
                            ),

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
  void authenticateReg() async{
    if(formKey.currentState!.validate()){
      userController.authenticate(emailController.text.trim())
          .then((value) {
        if(value){
          registationV();
        }else{
          Fluttertoast.showToast(msg: 'This Email already someone else use. Try another email');
        }
      });
    }
  }

  void registationV() async{
    final userModel = UserModel(
        1,
        nameController.text.trim(),
        emailController.text.trim(),
        passController.text.trim()
    );
  userController.registion(userModel).then((value) {
    if(value){
      Fluttertoast.showToast(msg: 'Congratulations, you are signup successfully ');
    }else{
      Fluttertoast.showToast(msg: 'Error occured, Please try again');
    }
  });
  }
}
