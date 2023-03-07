import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled3/LoginController.dart';


void main() {
  final LoginController c = Get.put(LoginController());

  group('FormEmailValidators', () {
    test('returns "Please enter your email address" when value is null', () {
      final result = c.FormEmailValidators(null);
      expect(result, 'Please enter your email address');
    });

    test('returns "Please enter your email address" when value is empty', () {
      final result = c.FormEmailValidators('');
      expect(result, 'Please enter your email address');
    });

    test('return "Please enter a valid email address xxxxx@xxxxx.xxx" when value is invalid',(){
      final result = c.FormEmailValidators('17318931789');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('return "Please enter a valid email address xxxxx@xxxxx.xxx" when value is invalid',(){
      final result = c.FormEmailValidators('nnnnnnnnnnnnn');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('return "Please enter a valid email address xxxxx@xxxxx.xxx" when value is invalid',(){
      final result = c.FormEmailValidators('........');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');

    });

    test('return "Please enter a valid email address xxxxx@xxxxx.xxx" when value is invalid',(){
      final result = c.FormEmailValidators('         ');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('returns "Please enter a valid email address xxxxx@xxxxx.xxx" when value is invalid due to missing domain', () {
      final result = c.FormEmailValidators('john.doe@');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('returns "Please enter a valid email address xxxxx@xxxxx.xxx" when value is invalid due to invalid domain', () {
      final result = c.FormEmailValidators('john.doe@example..com');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('returns "Please enter a valid email address xxxxx@xxxxx.xxx" when value is invalid due to invalid email format', () {
      final result = c.FormEmailValidators('john.doeexample.com');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('returns "Please enter a valid email address xxxxx@xxxxx.xxx" when value contains spaces', () {
      final result = c.FormEmailValidators('john doe@example.com');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('returns "Please enter a valid email address xxxxx@xxxxx.xxx" when value contains special characters', () {
      final result = c.FormEmailValidators('john.doe!@example.com');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('returns "Please enter a valid email address xxxxx@xxxxx.xxx" when value contains special characters', () {
      final result = c.FormEmailValidators('johndoe!@example.com');
      expect(result, 'Please enter a valid email address xxxxx@xxxxx.xxx');
    });

    test('returns "null" when value is valid', () {
      final result = c.FormEmailValidators('john123@example.com');
      expect(result, null);
    });

  });

  group('FormPhoneValidator',(){
    test('returns "Please enter phone number" when value is null', () {
      final result = c.FormPhoneValidators('');
      expect(result, "Please enter phone number");
    });

    test('returns "Please enter phone number" when value is null', () {
      final result = c.FormPhoneValidators(null);
      expect(result, "Please enter phone number");
    });

    test('returns "Please enter a valid phone number xxx-xxxxxxxx" when value is < 10 digit', () {
      final result = c.FormPhoneValidators('11111');
      expect(result, "Invalid phone number,The valid number example: xxx-xxxxxxx");
    });

    test('returns "Invalid phone number,The valid number example: xxx-xxxxxxx" when value is < 10 digit', () {
      final result = c.FormPhoneValidators('adfghj');
      expect(result, "Invalid phone number,The valid number example: xxx-xxxxxxx");
    });

    test('returns "Invalid phone number,The valid number example: xxx-xxxxxxx" when value is < 10 digit', () {
      final result = c.FormPhoneValidators('01221-1212122');
      expect(result, "Invalid phone number,The valid number example: xxx-xxxxxxx");
    });

    test('returns "null" when value is = 10 digit', () {
      final result = c.FormPhoneValidators('012-1111111');
      expect(result, null);
    });

  });

  group('FormPasswordValidators', () {
    test('returns "Please enter password" when value is null', () {
      final result = c.FormPasswordValidators('');
      expect(result, "Please enter password");
    });

    test('returns "Please enter password" when value is null', () {
      final result = c.FormPasswordValidators(null);
      expect(result, "Please enter password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special" when value is invalid', () {
      final result = c.FormPasswordValidators('abcsna');
      expect(result, "Password should contain Capital, small letter & NUmber & Special");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special" when value is invalid', () {
      final result = c.FormPasswordValidators('111111');
      expect(result, "Password should contain Capital, small letter & NUmber & Special");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special" when value is invalid', () {
      final result = c.FormPasswordValidators('AAAAAA');
      expect(result, "Password should contain Capital, small letter & NUmber & Special");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special" when value is invalid', () {
      final result = c.FormPasswordValidators('%%%%%%%');
      expect(result, "Password should contain Capital, small letter & NUmber & Special");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special" when value is invalid', () {
      final result = c.FormPasswordValidators('Abbbb');
      expect(result, "Password should contain Capital, small letter & NUmber & Special");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special" when value is invalid', () {
      final result = c.FormPasswordValidators('CCCCC@@@');
      expect(result, "Password should contain Capital, small letter & NUmber & Special");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special" when value is invalid', () {
      final result = c.FormPasswordValidators('cccccc@@@@@');
      expect(result, "Password should contain Capital, small letter & NUmber & Special");
    });

    test('returns "Null" when value is valid', () {
      final result = c.FormPasswordValidators('Abc123@');
      expect(result, null);
    });
  });

  group('FormConfirmPasswordValidators', () {
    test('returns "Please enter password" when value is null', () {
      final result = c.FormCPasswordValidators('');
      expect(result, "Please enter password");
    });

    test('returns "Please enter password" when value is null', () {
      final result = c.FormCPasswordValidators(null);
      expect(result, "Please enter password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special And match with password" when value is invalid', () {
      final result = c.FormCPasswordValidators('abcsna');
      expect(result, "Password should contain Capital, small letter & NUmber & Special And match with password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special And match with password" when value is invalid', () {
      final result = c.FormCPasswordValidators('111111');
      expect(result, "Password should contain Capital, small letter & NUmber & Special And match with password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special And match with password', () {
      final result = c.FormCPasswordValidators('AAAAAA');
      expect(result, "Password should contain Capital, small letter & NUmber & Special And match with password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special And match with password" when value is invalid', () {
      final result = c.FormCPasswordValidators('%%%%%%%');
      expect(result, "Password should contain Capital, small letter & NUmber & Special And match with password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special And match with password" when value is invalid', () {
      final result = c.FormCPasswordValidators('Abbbb');
      expect(result, "Password should contain Capital, small letter & NUmber & Special And match with password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special And match with password" when value is invalid', () {
      final result = c.FormCPasswordValidators('CCCCC@@@');
      expect(result, "Password should contain Capital, small letter & NUmber & Special And match with password");
    });

    test('returns "Password should contain Capital, small letter & NUmber & Special And match with password" when value is invalid', () {
      final result = c.FormCPasswordValidators('cccccc@@@@@');
      expect(result, "Password should contain Capital, small letter & NUmber & Special And match with password");
    });

  });

  group('FormUserNameValidators', () {
    test('returns "Please enter your name" when value is null', () {
      final result = c.FormBuilderUserNameValidators('');
      expect(result, "Please enter your name");
    });

    test('returns "Please enter your name" when value is null', () {
      final result = c.FormBuilderUserNameValidators(null);
      expect(result, "Please enter your name");
    });

    test('returns "Must need use alphabet include one Uppercase and Lowercase" when value is invalid', () {
      final result = c.FormBuilderUserNameValidators('A11');
      expect(result, "Name must be at least 4 characters long");
    });

    test('returns "Name must be at least 4 characters long" when value is invalid', () {
      final result = c.FormBuilderUserNameValidators('Mic');
      expect(result, 'Name must be at least 4 characters long');
    });

    test('returns "name must be one uppercase and lowercase" when value is <4', () {
      final result = c.FormBuilderUserNameValidators('ascdsd');
      expect(result, "name must be one uppercase and lowercase");
    });

    test('returns "name must be one uppercase and lowercase" when value is <4', () {
      final result = c.FormBuilderUserNameValidators('AAAAAAAA');
      expect(result, "name must be one uppercase and lowercase");
    });

    test('returns "name must be one uppercase and lowercase" when value is invalid', () {
      final result = c.FormBuilderUserNameValidators('AAAA AAAA');
      expect(result, "name must be one uppercase and lowercase");
    });

    test('returns "null " when value is invalid', () {
      final result = c.FormBuilderUserNameValidators('MicheaLac');
      expect(result, null);
    });

    test('returns "name must be one uppercase and lowercase" when value is valid', () {
      final result = c.FormBuilderUserNameValidators('Micheal Ng');
      expect(result, "name must be one uppercase and lowercase");
    });

    test('returns "name must be one uppercase and lowercase" when value is valid', () {
      final result = c.FormBuilderUserNameValidators('Micheal ng');
      expect(result, "name must be one uppercase and lowercase");
    });

    test('returns "name must be one uppercase and lowercase" when value is valid', () {
      final result = c.FormBuilderUserNameValidators('Micheal_Ng');
      expect(result, "name must be one uppercase and lowercase");
    });

    test('returns "null" when value is valid', () {
      final result = c.FormBuilderUserNameValidators('MichealNg');
      expect(result, null);
    });
  });

  group('FormDateValidators',() {
    test('returns "Please select your birthday date." when the value is null',(){
      final result = c.FormDateValidators('');
      expect(result, "Please select your birthday date.");
    });

    test('returns "Please select your birthday date. "when the value is Empty',(){
      final result = c.FormDateValidators(null);
      expect(result, "Please select your birthday date.");
    });

    test('returns "Null" when select is more than 18 ages',(){
      final result = c.FormDateValidators('2005-12-31');
      expect(result, null);
    });

  });

}

