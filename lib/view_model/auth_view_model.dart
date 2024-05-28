import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:single_sign_on/model/LoginPayload.dart';
import 'package:single_sign_on/repository/auth_repository.dart';
import 'package:single_sign_on/utils/apputil.dart';
import 'package:single_sign_on/utils/routes/routes_name.dart';

import '../view/OtpScreen.dart';

class AuthViewModel with ChangeNotifier {
  final _myRepo = AuthRepository();

  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context,
      Function(String token) onLoginPressed) async {
    setLoading(true);
    _myRepo.loginApi(data).then((value) {
      setLoading(false);
      Map<String, dynamic> mapData = jsonDecode(data);
      var usernamr = mapData['username'];
      Navigator.pushNamed(
        context,
        RoutesName.otp,
        arguments: {'username': usernamr, 'call_back': onLoginPressed},
      );

      print("====================>>>>>  " + value.toString());
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      print("====================>>>>>errorrrr  " + error.toString());
    });
  }

  Future<String?> validateOtp(dynamic data, BuildContext context) async {
    try{
      setLoading(true);
      var value = await _myRepo.otpValidation(data);
      var token = value['data']['token'];
      print("====================>>>>>  ");
      return token;
    }catch(e){
      setLoading(false);
      Utils.flushBarErrorMessage(e.toString(), context);
      return "";
    }


    /*_myRepo.otpValidation(data).then((value) {
      setLoading(false);
      var token = value['data']['token'];
      print("====================>>>>>  ");

      *//*Navigator.pushNamed(context, RoutesName.normal,
          arguments: {'tokenJson': value.toString()});*//*
      Utils.toastMessage("Token : " + token);
      print("====================>>>>>  " + value.toString());
      return token;
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      print("====================>>>>>errorrrr  " + error.toString());
      return null;
    });*/
  }

  Future<void> googlesigin(dynamic data, BuildContext context) async {
    setLoading(true);
    _myRepo.googleSignin(data).then((value) {
      setLoading(false);
      print("====================>>>>>  " + value.toString());
      dynamic url = value['data'];
      Navigator.pushNamed(context, RoutesName.web_view,
          arguments: {'authUrl': url});
      //     arguments: {'tokenJson': value.toString()});
      print("====================>>>>>  " + value.toString());
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
      print("====================>>>>>errorrrr  " + error.toString());
    });
  }
}
