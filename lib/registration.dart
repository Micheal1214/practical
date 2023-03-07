import 'dart:convert';
import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:blinkid_flutter/recognizers/blink_id_combined_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:untitled3/blinkId.dart';
import 'package:untitled3/home.dart';
import 'DatabaseHandler/DatabaseHelper.dart';
import 'FormController.dart';
import 'LoginController.dart';


class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    child: Scaffold(
      appBar: AppBar(
       title: Text("Register"),
            leading: IconButton(
               onPressed: (){
                 Get.back(result: () => LoginApp());
               },
               icon:Icon(Icons.arrow_back_ios),
               //replace with our own icon data.
            )
          ),
        body: MyCustomForm(),
      ));
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final LoginController c = Get.put(LoginController()); //at LoginController
  final FormController f = Get.put(FormController());
  var dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  late User? user = null;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }
    @override
    Widget build(BuildContext context) {
      // Build a Form widget using the _formKey created above.
      return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //name
                f.buildNameFormField(),
                //date
                f.buildDateFormField(context),
                //gender
                f.buildGenderFormField(),
                //email
                f.buildEmailFormField(),
                //phoneNumber
                f.buildPhoneFormField(),
                //password
                f.buildPasswordFormField(),
                //confirm password
                f.buildConfirmPasswordFormField(),
                //submit button
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 130),
                    child: ElevatedButton(style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          var users = User(
                            userName: c.userTextField.text,
                            email: c.emailTextField.text,
                            phone: c.phoneTextField.text,
                            password: c.passwordTextField.text,
                            confirmPassword: c.confirmPasswordTextField.text,
                            date: c.dateTextField.text,
                            gender: f.dropdownValue.value,
                            id: user?.id,);
                          DatabaseHelper.updateUser(users);
                          Get.to(() =>
                              Userpage(email: c.emailTextField.text,
                                  password: c.passwordTextField.text));
                          //signup screen
                        }
                      }, child: Text("Submit"),
                    ))
              ],),));
    }
  }