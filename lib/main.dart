import 'package:flutter/material.dart';
import 'package:untitled3/LoginController.dart';
import 'package:get/get.dart';
import '';

void main() {runApp(MyApp());}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginApp(),
    );
  }
}