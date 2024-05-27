class AppUrl {
  static var baseUrl = 'https://portal.emmdev.tectoro.com/idm/v1';
  static var loginEndPoint = baseUrl + '/auth/local/login';
  static var otpEndPoint = baseUrl + '/auth/local/tfa';
  static var googleSginEndPoint = baseUrl + '/auth/oidc/signin';
}
