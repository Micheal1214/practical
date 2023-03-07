import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "dart:convert";
import "dart:async";
import 'package:untitled3/registration.dart';
import 'DatabaseHandler/DatabaseHelper.dart';
import 'FormController.dart';
import 'LoginController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _resultString = "";
  String _fullDocumentFrontImageBase64 = "";
  String _fullDocumentBackImageBase64 = "";
  String _faceImageBase64 = "";

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

    if (results.length == 0) return;
    for (var result in results) {
      if (result is BlinkIdCombinedRecognizerResult) {
        if (result.mrzResult?.documentType == MrtdDocumentType.Passport) {
          _resultString = getPassportResultString(result);
        } else {
          _resultString = getIdResultString(result);
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
          buildResult(result.dateOfExpiryPermanent.toString(),"Date of expiry permanent") +
          buildResult(result.maritalStatus, "Martial status") +
          buildResult(result.personalIdNumber, "Personal Id Number") +
          buildResult(result.profession, "Profession") +
          buildResult(result.race, "Race") +
          buildResult(result.religion, "Religion") +
          buildResult(result.residentialStatus, "Residential Status") +
          buildDriverLicenceResult(result.driverLicenseDetailedInfo) +
          buildDataMatchDetailedInfoResult(result.dataMatchDetailedInfo);
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
        "${result.day}.${result.month}.${result.year}", propertyName);
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
    final LoginController c = Get.put(LoginController()); //at LoginController
    final FormController f = Get.put(FormController());
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("BlinkID"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
              Text(_resultString),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical:32.0,horizontal: 130),
                  child: ElevatedButton (style:ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15,horizontal:15 )),
                    onPressed:() async {

                        var users = User(
                          userName:c.userTextField.text,
                          email: c.emailTextField.text,
                          phone:  c.phoneTextField.text,
                          password: c.passwordTextField.text,
                          confirmPassword: c.confirmPasswordTextField.text,
                          date:c.dateTextField.text,
                          gender: f.dropdownValue.value,
                          id:user?.id,);
                        DatabaseHelper.addUser(users);
                        Get.to(() => Register());
                        //signup screen

                    }, child: Text("Submit"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}