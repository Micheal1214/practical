import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled3/DatabaseHandler/DatabaseHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled3/FormController.dart';
import 'package:untitled3/LoginController.dart';

class Userpage extends StatefulWidget {
   const Userpage({Key? key, required this.email, required this.password}) : super(key: key);
   final String email ;
   final String password ;
  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  bool _editing = false;
  bool isEditable = false;
  late User? user = null;
  bool _isHidden = true;
  final LoginController c = Get.find(); //at LoginController
  var dbHelper=DatabaseHelper();
  final FormController f = Get.find();

  @override
  void initState() {
    super.initState();
    getUserData();
  }
  Future<void> _saveData() async {
    var users = User(
      id:user?.id,
      userName: c.userTextField.text,
      email: c.emailTextField.text,
      phone: c.phoneTextField.text,
      password: c.passwordTextField.text,
      confirmPassword: c.confirmPasswordTextField.text,
      date: c.dateTextField.text,
      gender: f.dropdownValue.value,

    );
    print(users);
    DatabaseHelper.updateUser(users);

  }

  void getUserData() async {
    User? retrievedUser = await DatabaseHelper.getEmail(widget.email);
    if (retrievedUser != null && retrievedUser.password == widget.password) {
      setState(() {
        user = retrievedUser;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
        child:Scaffold(
            appBar: AppBar(
                title: Text("User Profile"),
                leading: IconButton(
                  onPressed: (){
                    Get.back(result: () => LoginApp());
                  },
                  icon:Icon(Icons.arrow_back_ios),
                  //replace with our own icon data.
                )
            ),
            body:SingleChildScrollView(
              child:user != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${user?.id }'),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      enabled: isEditable,
                      initialValue: user?.userName,
                      decoration: const InputDecoration(
                          labelText: 'User Name'),
                      validator: c.FormBuilderUserNameValidators,
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child:TextFormField(
                      initialValue:user?.date,
                      enabled: false,
                      decoration:  const InputDecoration(
                        labelText: 'Birthday Date',
                      ),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child:TextFormField(
                      enabled: false,
                      initialValue: user?.gender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ) ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child:TextFormField(
                      enabled: isEditable,
                      initialValue: user?.phone,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: c.FormPhoneValidators,
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      enabled: isEditable,
                      initialValue:user?.email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: c.FormEmailValidators,)),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child:TextFormField(
                      enabled: isEditable,
                      obscureText: _isHidden,
                      obscuringCharacter: "*",
                      initialValue:user?.password,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: c.FormPasswordValidators,)),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child:TextFormField(
                      enabled: isEditable,
                      obscureText: _isHidden,
                      obscuringCharacter: "*",
                      initialValue: user?.confirmPassword,
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                      validator: c.FormCPasswordValidators,)),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditable = !isEditable;
                      _saveData();
                    });
                  },
                  child: Text(isEditable ? 'Save' : 'Edit'),
                ),],) : Container(),)));
  }
  void _toggleEditing() {
    setState(() {
      _editing = true;
    });
  }
  void _togglePasswordView(){
    setState(() {
      _isHidden=! _isHidden;
    });
  }
}