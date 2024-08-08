import 'package:single_sign_on/data/network/base_api_services.dart';
import 'package:single_sign_on/data/network/network_api_services.dart';
import 'package:single_sign_on/res/app_url.dart';

class AuthRepository {
  BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data,String baseUrl) async {
    try {
      String url = baseUrl+"/idm/v1/auth/local/login";
      dynamic response =
          _apiServices.getPostApiResponse(url, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> getRegistry(String tenant) async {
    try {
      String url = 'https://api.mdmdev.tectoro.com/registry/v1/accounts';
      dynamic response =
          _apiServices.getApiWithPathParam(url, tenant);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> ldapApi(dynamic data,String baseUrl) async {
    try {
      String url = baseUrl+'/idm/v1/auth/ldap/login';
      dynamic response =
          _apiServices.getPostApiResponse(url, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> otpValidation(dynamic data,String baseUrl) async {
    try {
      String url = baseUrl+'/idm/v1/auth/local/tfa';
      dynamic response =
          _apiServices.getPostApiResponse(url, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> googleSignin(dynamic data,String baseUrl) async {
    try {
      String url = baseUrl+'/idm/v1/auth/oidc/signin';
      dynamic response = _apiServices.getGetApiResponseWithQuery(
          url, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> validateCode(dynamic data,String baseUrl) async {
    try {
      String url = baseUrl+'/idm/v1/auth/oidc/callback';
      dynamic response =
          _apiServices.getPostApiResponse(url, data);
      return response;
    } catch (e) {
      throw e;
    }
  }

  getAuthModes(String tenant, String baseUrl) {
    try {
      String url = baseUrl + "/idm/v1/authmodes/tenant";
      dynamic response = _apiServices.getApiWithPathParam(url, tenant);
      return response;
    } catch (e) {
      throw e;
    }
  }
}
