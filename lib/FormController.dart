import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/material/icons.dart';
import 'LoginController.dart';
import 'blinkId.dart';

const List<String> list = <String>['Select Your gender','Male', 'Female', 'Other'];

class FormController extends GetxController {
  final LoginController c = Get.put(LoginController());
  RxBool _isHidden = true.obs;
  final Scan = MyApp();

  Widget buildEmailFormField() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: c.emailTextField,
          style: TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            icon: const Icon(Icons.email),
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
            border: OutlineInputBorder(),
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
        child:
        TextFormField(readOnly: true,
          validator: c.FormDateValidators,
          controller: c.dateTextField,
          decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today_rounded),
              border: OutlineInputBorder(),
              labelText: "Select Birthday Date"
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime(2200));
            if (pickedDate != null) {
              print(pickedDate);
              String formattedDate = DateFormat('yyyy-MM-dd').format(
                  pickedDate);
              print(formattedDate);
              c.dateTextField.text = formattedDate;
            } else {
              print("Date is not selected");
            }
          },
        ));
  }

  var dropdownValue = list.first.obs;

  Widget buildNameFormField() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: c.userTextField,
          decoration: const InputDecoration(
            icon: const Icon(Icons.person),
            border: OutlineInputBorder(),
            hintText: 'Enter your name',
            labelText: 'Name',
          ),
          validator: c.FormBuilderUserNameValidators,
        ));
  }

  Widget buildGenderFormField() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Obx(() =>
            DropdownButton<String>(
              value: dropdownValue.value,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String? value) {
                dropdownValue.value = value!;
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )));
  }

  Widget buildPhoneFormField() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child:
        TextFormField(
          controller: c.phoneTextField,
          decoration: const InputDecoration(
            icon: const Icon(Icons.phone),
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
            border: OutlineInputBorder(),
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
