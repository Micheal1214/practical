import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:blinkid_flutter/recognizer.dart';
import 'package:blinkid_flutter/recognizers/blink_id_combined_recognizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:untitled3/blinkId.dart';
import 'LoginController.dart';


const List<String> list = <String>['Select Your gender','Male', 'Female', 'Other'];

class FormController extends GetxController {
  final LoginController c = Get.put(LoginController());
  final RxBool _isHidden = true.obs;

   BlinkIdCombinedRecognizerResult? result;

  Widget buildEmailFormField() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: c.emailTextField,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            icon: Icon(Icons.email),
            border: OutlineInputBorder(),
            hintText: 'Enter an email',
            labelText: 'Email',
          ),
          validator: c.FormEmailValidators,
        ));
  }

  Widget buildPasswordFormField() {
    return Obx(() {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          obscureText: _isHidden.value,
          obscuringCharacter: "*",
          controller: c.passwordTextField,
          decoration: InputDecoration(
            icon: const Icon(Icons.password),
            border: const OutlineInputBorder(),
            hintText: 'Enter a password',
            labelText: 'Password',
            suffix: InkWell(
              onTap: _togglePasswordView,
              child: Icon(
                  _isHidden.value ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          validator: c.FormPasswordValidators,
        ),
      );
    });
  }

  Widget buildDateFormField(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
            controller:c.dateTextField,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today_rounded),
              border: OutlineInputBorder(),
              hintText: 'Enter your date',
              labelText: 'Date',
            ),
            validator: c.FormDateValidators,
          ),
        ],
      ),
    );
  }

  Widget buildNameFormField() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextFormField(
            controller:c.userTextField,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              border: OutlineInputBorder(),
              hintText: 'Enter your name',
              labelText: 'Name',
            ),
            validator: c.FormBuilderUserNameValidators,
          ),
        ],
      ),
    );
  }


  Widget buildGenderFormField() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: c.genderTextField,
          decoration: const InputDecoration(
            icon: Icon(Icons.transgender),
            border: OutlineInputBorder(),
            hintText: 'Enter your gender',
            labelText: 'Gender',
          ),
        ));
  }

  Widget buildPhoneFormField() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child:
        TextFormField(
          controller: c.phoneTextField,
          decoration: const InputDecoration(
            icon: Icon(Icons.phone),
            border: OutlineInputBorder(),
            hintText: 'Enter a phone number',
            labelText: 'Phone',
          ),
          validator: c.FormPhoneValidators,
        ));
  }

  void _togglePasswordView() {
    _isHidden.toggle();
  }

  Widget buildConfirmPasswordFormField() {
    return Obx(() {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          obscureText: _isHidden.value,
          obscuringCharacter: "*",
          controller: c.confirmPasswordTextField,
          decoration: InputDecoration(
            icon: const Icon(Icons.password),
            border: const OutlineInputBorder(),
            hintText: 'Enter a confirm password',
            labelText: 'Confirm Password',
            suffix: InkWell(
              onTap: _togglePasswordView,
              child: Icon(
                  _isHidden.value ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          validator: c.FormCPasswordValidators,
        ),
      );
    });
  }


}