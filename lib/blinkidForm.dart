import 'dart:convert';
import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class blinkId extends StatefulWidget {
  const blinkId({Key? key}) : super(key: key);

  @override
  State<blinkId> createState() => _blinkIdState();
}

class _blinkIdState extends State<blinkId> {
  String resultString = "";
  String _fullDocumentFrontImageBase64 = "";
  String _fullDocumentBackImageBase64 = "";
  String _faceImageBase64 = "";
  final _formKey = GlobalKey<FormState>();


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
          resultString = getPassportResultString(result);
        } else {
          resultString = getIdResultString(result);
        }

        setState(() {
          resultString = resultString;
          _fullDocumentFrontImageBase64 = result.fullDocumentFrontImage ?? "";
          _fullDocumentBackImageBase64 = result.fullDocumentBackImage ?? "";
          _faceImageBase64 = result.faceImage ?? "";
        });

        return;
      }
    }
  }

  Column getIdResultString(BlinkIdCombinedRecognizerResult result) {
    var fullName = result.fullName;
    var address = result.address;
    var sex = result.sex;
    var dateOfBirth = result.dateOfBirth?.toString();
    var race = result.race;
    return Column(
      children: [
        Container(
          child: TextFormField(
            initialValue: result.fullName,
            decoration: InputDecoration(labelText: 'Full name'),
          ),
        ),
        Container(
          child: TextFormField(
            initialValue: result.address,
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        Container(
          child: TextFormField(
            initialValue: result.sex,
            decoration: InputDecoration(labelText: 'Gender'),
          ),
        ),
        Container(
          child: TextFormField(
            initialValue: result.dateOfBirth?.toString(),
            decoration: InputDecoration(labelText: 'Birthday date'),
          ),
        ),
        Container(
          child: TextFormField(
            initialValue: result.race,
            decoration: InputDecoration(labelText: 'Race'),
          ),
        ),
      ],
    );
  }

  String getPassportResultString(BlinkIdCombinedRecognizerResult result) {
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

    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            faceImage,
            fullDocumentFrontImage,
            fullDocumentBackImage,
            getIdResultString(result),
          ],
        ),
      );
    }
  }



