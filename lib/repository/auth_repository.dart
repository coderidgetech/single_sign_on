import 'package:single_sign_on/data/network/base_api_services.dart';
import 'package:single_sign_on/data/network/network_api_services.dart';
import 'package:single_sign_on/res/app_url.dart';

class AuthRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
          _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> ldapApi(dynamic data) async {
    try {
      dynamic response =
      _apiServices.getPostApiResponse(AppUrl.ldapEndPoint, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> otpValidation(dynamic data) async {
    try {
      dynamic response =
          _apiServices.getPostApiResponse(AppUrl.otpEndPoint, data);
      return response;
    } catch (e) {
      throw e;
    }
  }


  Future<dynamic> googleSignin(dynamic data) async {
    try {
      dynamic response =
      _apiServices.getGetApiResponseWithQuery(AppUrl.googleSginEndPoint, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> validateCode(dynamic data) async {
    try {
      dynamic response =
      _apiServices.getPostApiResponse(AppUrl.codeToTokenEndPoint, data);
      return response;
    } catch (e) {
      throw e;
    }
  }


}
