import 'dart:convert';
import 'dart:developer';
import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:blinkid_flutter/overlays/blinkid_overlays.dart';
import 'package:blinkid_flutter/recognizer.dart';
import 'package:blinkid_flutter/recognizers/blink_id_combined_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:intl/intl.dart';
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

class MyCustomFormState extends State<MyCustomForm> {
  String _fullDocumentFrontImageBase64 = "";
  String _fullDocumentBackImageBase64 = "";
  String _faceImageBase64 = "";
  String _resultString ="";
  String name = "" ;
  String sex = "" ;

  final LoginController c = Get.find();
  final FormController f = Get.find();
  var dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  late User? user = null;

  Future<void> scan() async {
    String license;
    if (Theme
        .of(context)
        .platform == TargetPlatform.iOS) {
      license =
      "sRwAAAEQY29tLmZsLnByYWN0aWNhbI1yy/sxexmp65AovSJP7+ckgtcYQSh+UdPymBGA0GVXLNx5cqRfIXlAg6EqzK/yeUqibt1YuXc2JtjwIyCV0vzHUmr8qKLsP4oEEN90McpQLigP8TxeZyXLi6X5gJSx3ahJlEZXqLUzUDNlpSt9Y+Q9DCQNCMg+vmnL588raB0GbA+P87v2Bow9BZo7rV7qhRPTApagziVn+G7hC8FmkZLvFybLkXMp36Ts4wMAeHo+";
    } else if (Theme
        .of(context)
        .platform == TargetPlatform.android) {
      license =
      "sRwAAAAQY29tLmZsLnByYWN0aWNhbM12kBBYe5n6LSuRml/whaHMKY2TolCi+jLzNld4zm6sQ8Y65Jceo+nVh4Xps65zrRuGAP34sfhjrX2oiYnt7bC0vxf30EGsVQ1gtdyVMu3gScZ3KKGdL+K8gBLmrc62nO09qUCPKMW6v8NMS54RqrafpVsYO6iGXWFYS6+Bm1qLg5nX5GsSZ1fmTnzHOAfM7pcG6wnZ1NSLSMJlO9RNf1+X54DRHB/GgGuIrYwWDZ4D";
    } else {
      license = "";
    }

    var idRecognizer = BlinkIdCombinedRecognizer();
    idRecognizer.returnFullDocumentImage = true;
    idRecognizer.returnFaceImage = true;

    BlinkIdOverlaySettings settings = BlinkIdOverlaySettings();

    var results = await MicroblinkScanner.scanWithCamera(
        RecognizerCollection([idRecognizer]), settings, license);

    if (!mounted) return;

    if (results.isEmpty) return;
    for (var result in results) {
      if (result is BlinkIdCombinedRecognizerResult) {
        if (result.mrzResult?.documentType == MrtdDocumentType.Passport) {
          _resultString = getPassportResultString(result);
          name = result.fullName!;
          c.userTextField.text = name;
          sex = result.sex!;
          c.genderTextField.text = sex;
        } else {
          _resultString = getIdResultString(result);
         // name = '${result.firstName!} ${result.lastName!}';
          name = result.fullName!;
          c.userTextField.text = name;
          sex = result.sex!;
          c.genderTextField.text = sex;

          if (result.dateOfBirth != null) {
            Date dateOfBirth = result.dateOfBirth!;
            int? year = dateOfBirth.year ?? DateTime.now().year;
            int? month = dateOfBirth.month ?? DateTime.now().month;
            int? day = dateOfBirth.day ?? DateTime.now().day;
            DateTime dateTimeOfBirth = DateTime(year, month, day);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTimeOfBirth);
            print('Birthdate: $formattedDate');
            c.dateTextField.text = formattedDate;
          }
        }
        setState(() {
          _resultString = _resultString;
          _fullDocumentFrontImageBase64 = result.fullDocumentFrontImage ?? "";
          _fullDocumentBackImageBase64 = result.fullDocumentBackImage ?? "";
          _faceImageBase64 = result.faceImage ?? "";
        });
        return;
      }
    }
  }


  String buildResult(String? result, String propertyName) {
    if (result == null || result.isEmpty) {
      return "";
    }

    return propertyName + ": " + result + "\n";
  }

  String buildDateResult(Date? result, String propertyName) {
    if (result == null || result.year == 0) {
      return "";
    }

    return buildResult(
        "${result.year}-${result.month}-${result.day}", propertyName);
  }

  String buildIntResult(int? result, String propertyName) {
    if (result == null || result < 0) {
      return "";
    }

    return buildResult(result.toString(), propertyName);
  }

  String buildDriverLicenceResult(DriverLicenseDetailedInfo? result) {
    if (result == null) {
      return "";
    }

    return buildResult(result.restrictions, "Restrictions") +
        buildResult(result.endorsements, "Endorsements") +
        buildResult(result.vehicleClass, "Vehicle class") +
        buildResult(result.conditions, "Conditions");
  }

  String buildDataMatchDetailedInfoResult(DataMatchDetailedInfo? result) {
    if (result == null) {
      return "";
    }

    return buildResult(result.dateOfBirth?.toString(), "Date of birth") +
        buildResult(result.dateOfExpiry?.toString(), "Date Of Expiry") +
        buildResult(result.documentNumber?.toString(), "Document Number") +
        buildResult(result.dataMatchResult?.toString(), "Data Match Result");
  }
  String getIdResultString(BlinkIdCombinedRecognizerResult result) {
    return
      buildResult(result.firstName, "First name") +
          buildResult(result.lastName, "Last name") +
          buildResult(result.fullName, "Full name") +
          buildResult(result.localizedName, "Localized name") +
          buildResult(result.additionalNameInformation, "Additional name info") +
          buildResult(result.address, "Address") +
          buildResult(result.additionalAddressInformation, "Additional address info") +
          buildResult(result.documentNumber, "Document number") +
          buildResult(result.documentAdditionalNumber, "Additional document number") +
          buildResult(result.sex, "Sex") +
          buildResult(result.issuingAuthority, "Issuing authority") +
          buildResult(result.nationality, "Nationality") +
          buildDateResult(result.dateOfBirth, "Date of birth") +
          buildIntResult(result.age, "Age") +
          buildDateResult(result.dateOfIssue, "Date of issue") +
          buildDateResult(result.dateOfExpiry, "Date of expiry") +
          buildResult(result.dateOfExpiryPermanent.toString(), "Date of expiry permanent") +
          buildResult(result.maritalStatus, "Martial status") +
          buildResult(result.personalIdNumber, "Personal Id Number") +
          buildResult(result.profession, "Profession") +
          buildResult(result.race, "Race") +
          buildResult(result.religion, "Religion") +
          buildResult(result.residentialStatus, "Residential Status") +
          buildDriverLicenceResult(result.driverLicenseDetailedInfo) +
          buildDataMatchDetailedInfoResult(result.dataMatchDetailedInfo);

  }

  String getPassportResultString(BlinkIdCombinedRecognizerResult? result) {
    if (result == null) {
      return "";
    }

    var dateOfBirth = "";
    if (result.mrzResult?.dateOfBirth != null) {
      dateOfBirth = "Date of birth: ${result.mrzResult!.dateOfBirth?.day}."
          "${result.mrzResult!.dateOfBirth?.month}."
          "${result.mrzResult!.dateOfBirth?.year}\n";
    }

    var dateOfExpiry = "";
    if (result.mrzResult?.dateOfExpiry != null) {
      dateOfExpiry = "Date of expiry: ${result.mrzResult?.dateOfExpiry?.day}."
          "${result.mrzResult?.dateOfExpiry?.month}."
          "${result.mrzResult?.dateOfExpiry?.year}\n";
    }

    return "First name: ${result.mrzResult?.secondaryId}\n"
        "Last name: ${result.mrzResult?.primaryId}\n"
        "Document number: ${result.mrzResult?.documentNumber}\n"
        "Sex: ${result.mrzResult?.gender}\n"
        "$dateOfBirth"
        "$dateOfExpiry";
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  @override
    Widget build(BuildContext context) {
      Widget fullDocumentFrontImage = Container();
      if (_fullDocumentFrontImageBase64 != null &&
          _fullDocumentFrontImageBase64 != "") {
        fullDocumentFrontImage = Column(
          children: <Widget>[
            const Text("Document Front Image:"),
            Image.memory(
              const Base64Decoder().convert(_fullDocumentFrontImageBase64),
              height: 180,
              width: 350,
            )
          ],
        );
      }

      Widget fullDocumentBackImage = Container();
      if (_fullDocumentBackImageBase64 != null &&
          _fullDocumentBackImageBase64 != "") {
        fullDocumentBackImage = Column(
          children: <Widget>[
            const Text("Document Back Image:"),
            Image.memory(
              const Base64Decoder().convert(_fullDocumentBackImageBase64),
              height: 180,
              width: 350,
            )
          ],
        );
      }

      Widget faceImage = Container();
      if (_faceImageBase64 != null && _faceImageBase64 != "") {
        faceImage = Column(
          children: <Widget>[
            const Text("Face Image:"),
            Image.memory(
              const Base64Decoder().convert(_faceImageBase64),
              height: 150,
              width: 100,
            )
          ],
        );
      }
      return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: TextButton(
                      child: const Text("Scan"),
                      onPressed: () => scan(),
                    )),
                faceImage,
                fullDocumentFrontImage,
                fullDocumentBackImage,
               Text( _resultString,),
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
                          String dateString = c.dateTextField.text;
                          DateTime dateTime = DateTime.parse(dateString);
                          Date date = Date(dateTime, dateTime.month, dateTime.day);
                            var users = User(
                              userName: c.userTextField.text,
                              email: c.emailTextField.text,
                              phone: c.phoneTextField.text,
                              password: c.passwordTextField.text,
                              confirmPassword: c.confirmPasswordTextField.text,
                              date: date,
                              gender: c.genderTextField.text,
                              id: user?.id,);
                            DatabaseHelper.addUser(users);
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