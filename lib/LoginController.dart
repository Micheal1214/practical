import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

class LoginController extends GetxController {

  TextEditingController userTextField= TextEditingController();
  TextEditingController emailTextField= TextEditingController();
  TextEditingController phoneTextField= TextEditingController();
  TextEditingController dropdownValue= TextEditingController();
  TextEditingController passwordTextField= TextEditingController();
  TextEditingController confirmPasswordTextField= TextEditingController();
  TextEditingController dateTextField= TextEditingController();


  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (birthDate.month > currentDate.month) {
      age--;
    } else if (currentDate.month == birthDate.month) {
      if (birthDate.day > currentDate.day) {
        age--;
      }
    }
    return age;
  }
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  RegExp cpass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  RegExp name_valid =  RegExp(r"^(?=.*[A-Z])(?=.*[a-z])[A-Za-z]+$");
   RegExp email_valid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  RegExp phone_valid = RegExp(r'^\d{3}-\d{7}$');
  String? gender;

  bool validatePassword(String pass){
    String _password= pass.trim();
    if(pass_valid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }

  bool validateCPassword(String pass){
    String _password= pass.trim();
    if(cpass_valid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }

  String? FormDateValidators(String? value){
    if(value == null || value.isEmpty){
      return 'Please select your birthday date.';
    }else if(calculateAge(DateTime.parse(value)) < 16 ){
      return 'You not 18 years old Please select again';
    }
    return null;
  }

  String? FormEmailValidators(String? value){
    if(value == null || value.isEmpty){
      return'Please enter your email address';
    }else if(email_valid.hasMatch(value)){
      return null;
    } else{
      return "Please enter a valid email address xxxxx@xxxxx.xxx";
      }
    }

  String? FormPhoneValidators(String? value){
    if(value == null || value.isEmpty){
      return "Please enter phone number";
    }else if (phone_valid.hasMatch(value)) {
      return null;
    } else {
   return "Invalid phone number,The valid number example: xxx-xxxxxxx";
    }
  }

  String? FormCPasswordValidators(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
    }else if(cpass_valid.hasMatch(value) && value == passwordTextField.text){
      return null;
    }else{
      return "Password should contain Capital, small letter & NUmber & Special And match with password";
    }
  }


  String? FormPasswordValidators(String? value){
    if(value == null || value.isEmpty){
      return"Please enter password";
    }else{
      bool result = validatePassword(value);
      if(result){
        return null;
      }else{
        return "Password should contain Capital, small letter & NUmber & Special";
      }
    }
  }
   String? FormBuilderUserNameValidators(String? value){
     if (value == null || value.isEmpty) {
       return 'Please enter your name';
     }
     else if (value.length < 4) {
       return 'Name must be at least 4 characters long';
     }else if(name_valid.hasMatch(value)){
       return null;
     }else{
       return "name must be one uppercase and lowercase";

     }
  }
}

class LoginApp extends StatelessWidget{
  final LoginController c = Get.put(LoginController());

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
                   appBar: AppBar(title: Text("Login")),
                   body: MyStatefulWidget(),
        ));

  }
}
