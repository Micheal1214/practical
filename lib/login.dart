import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:untitled3/blinkId.dart';
import 'package:untitled3/registration.dart';
import 'DatabaseHandler/DatabaseHelper.dart';
import 'FormController.dart';
import 'LoginController.dart';
import 'home.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final LoginController c = Get.put(LoginController());
  final FormController f = Get.put(FormController());
  final _formKey = GlobalKey<FormState>();
  late User? user;
  String? gender;

  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  bool validatePassword(String pass){
    String _password= pass.trim();
    if(pass_valid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key:_formKey,
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Welcome to Coding Life',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                ),
                //Email
                f.buildEmailFormField(),
                //Password
                f.buildPasswordFormField(),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text('Forgot Password',),
                ),
                //login button
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        User? user = await DatabaseHelper.getEmail(c.emailTextField.text);
                        if (user != null && user.password == c.passwordTextField.text) {
                          Get.to(() => Userpage(email: c.emailTextField.text, password: c.passwordTextField.text));
                        } else {
                          Get.snackbar(
                            'Error', 'Invalid email or password',
                            snackPosition: SnackPosition.BOTTOM,
                          );}}},),),
                //sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Does not have account?'),
                    TextButton(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),

                      ),
                      onPressed: () {
                        Get.to(Register());//signup screen
                      },),],),],)));
  }

}
