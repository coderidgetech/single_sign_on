import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/apputil.dart';
import '../view_model/auth_view_model.dart';
import 'LoginScreen.dart';
import 'PrelogWidgets/TenantInputWidget.dart';

class Prelogin extends StatefulWidget {
  final String baseUrl;
  final String tenant;
  final String deviceID;
  final String appName;
  final String loginTypes;
  final bool havingManagedConfig;

  final Function(String) onLoginPressed;

  Prelogin({
    // testing 1.0
    required this.onLoginPressed,
    required this.baseUrl,
    required this.tenant,
    required this.deviceID,
    required this.appName,
    required this.loginTypes,
    required this.havingManagedConfig,
  });

  @override
  _PreloginState createState() => _PreloginState();
}

class _PreloginState extends State<Prelogin> {
  final TextEditingController _tenantController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _handleConfig(authViewModel);
    });
  }

  void _handleConfig(AuthViewModel authViewModel) {
    if (widget.havingManagedConfig) {
      _navigateToLogin(widget.tenant, widget.baseUrl, widget.appName,
          widget.deviceID, widget.loginTypes);
    } else {
      _showTenantDialog(authViewModel);
    }
  }

  void _navigateToLogin(
    String tenant,
    String baseUrl,
    String appName,
    String deviceId,
    String loginTypes,
  ) {
    print("====laskdfjn >>> tenant : $tenant");
    print("====laskdfjn >>> baseurl : $baseUrl");
    print("====laskdfjn >>> appNAme : $appName");
    print("====laskdfjn >>> deviceId : $deviceId");
    print("====laskdfjn >>> loginTypes : $loginTypes");
    print(
        "====laskdfjn >>> havingManaged cOnfig : ${widget.havingManagedConfig}");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                onLoginPressed: widget.onLoginPressed,
                baseUrl: baseUrl,
                deviceID: deviceId,
                appName: appName,
                loginTypes: loginTypes,
                havingManagedConfig: widget.havingManagedConfig,
                tenant: tenant)));
    // widget.onLoginPressed(widget.tenant);
  }

  void _showTenantDialog(AuthViewModel authViewModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Tenant'),
          content: TextField(
            controller: _tenantController,
            decoration: InputDecoration(hintText: 'Tenant'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // widget.onLoginPressed(_tenantController.text);
                String tenant = _tenantController.text.toString();
                String appName = widget.appName;
                String deviceID = widget.deviceID;
                if (tenant == null || tenant.isEmpty) {
                  Utils.snackBar("Please Enter Tenant", context);
                  return;
                }
                print("====> Tenant is : " + tenant);
                hanldingRegistryApi(appName, tenant, deviceID, authViewModel);
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }

  void hanldingRegistryApi(String appName, String tenant, String deviceId,
      AuthViewModel authViewModel) async {
    try {
      // String? baseUrl = await authViewModel.callRegistryApi(tenant);
      String? baseUrl = await authViewModel.callRegistryApi(tenant);
      print("q===================object $baseUrl");
      if (baseUrl == null || baseUrl.isEmpty) {
        Utils.snackBar("Try again base url is $baseUrl", context);
        print("Try again base url is $baseUrl");
        return;
      }
      // baseUrl = 'https://portal.emmdev.tectoro.com';
      // tenant = "TT";
      bringAuthModes(
        appName,
        tenant,
        deviceId,
        baseUrl,
        authViewModel,
      );

      /* authViewModel.callregistryApi(tenant).then((baseUrl) {
        print("object");

      });*/
    } catch (e) {
      print("object  : " + e.toString());
    }
  }

  void bringAuthModes(String appName, String tenant, String deviceId,
      String baseUrl, AuthViewModel authViewModel) async {
    String loginTypes = await authViewModel.fetchAuthModes(tenant, baseUrl);
    print("object");

    if (loginTypes == null || loginTypes.isEmpty) {
      Utils.snackBar("Error in getting Authmodes are $loginTypes", context);
      return;
    }
    print("=======>> Authmoides are  $loginTypes");
    _navigateToLogin(tenant, baseUrl, appName, deviceId, loginTypes);
  }
}
