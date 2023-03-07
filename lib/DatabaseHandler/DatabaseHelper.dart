import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../LoginController.dart';

final LoginController c = Get.put(LoginController());
late User? user = null;
class User{
  int? id ;
  String userName;
  String date ;
  String gender;
  String email;
  String phone;
  String password;
  String confirmPassword;

  User({required this.userName,required this.date,required this.gender,required this.email,required this.phone, required this.password
    ,required this.confirmPassword, this.id});

  factory User.fromMap(Map<String,dynamic> map) => User(
    id: map['id'],
    userName: map['userName'],
    date: map['date'],
    gender: map ['gender'],
    email: map  ['email'],
    phone: map['phone'],
    password: map['password'],
    confirmPassword: map['confirmPassword'],
  );

  Map<String,dynamic>toMap()=> {
    'id': id,
    'userName': userName,
    'date': date,
    'gender': gender,
    'email': email,
    'phone': phone,
    'password': password,
    'confirmPassword': confirmPassword,
  };

}

class DatabaseHelper {

  static const _version = 1;
  static const _dbName = "User.db";

  static Future<Database> getDB() async {
    return openDatabase(
        join(await getDatabasesPath(), _dbName),
        onCreate: (Database db, version) async =>
        await db.execute('CREATE TABLE User (id INTEGER PRIMARY KEY, userName STRING NOT NULL,date STRING NOT NULL,gender STRING NOT NULL,email STRING NOT NULL,phone STRING NOT NULL,password STRING NOT NULL,confirmPassword STRING NOT NULL)'),
        version: _version
    );
  }

  static Future<int> addUser(User users) async {
    final db = await getDB();
    return await db.insert("User", users.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> saveUser(User users) async {
    final db = await getDB();
    await db.insert('User', users.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future updateUser(User users) async {
    final db = await getDB();
    return await db.update("User", users.toMap(),
        where: 'id=?', whereArgs: [users.id],
        conflictAlgorithm: ConflictAlgorithm.replace);

  }

  static Future<int> deleteUser(User users) async {
    final db = await getDB();
    return await db.delete("User",
        where: 'email=?', whereArgs: [users.email]);
  }

  static Future<List<User>?> getAllUser() async {
    final db = await getDB();
    final List<Map<String, dynamic>> maps = await db.query("User");

    if (maps.isEmpty) {
      return null;
    }
      return List.generate(maps.length, (index) => User.fromMap(maps[index])
      );
  }

  static Future<User?>getEmail(String email) async{
    final db = await getDB();
    List<Map<String,dynamic>> maps = await db.query('User',
        where: "email = ?", whereArgs: [email], limit: 1);
    print('map -> $maps, size ${maps.length}');
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } return null;
  }

}