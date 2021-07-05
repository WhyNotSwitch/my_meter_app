import 'package:flutter/material.dart';
import '../utils/shared_prefs.dart' as shared_prefs;
import '../utils/constants.dart' as constants;
import '../utils/api.dart' as api;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _tokenFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  bool _loading = false;
  bool _processing = false;
  bool _emailEnabled = true;
  bool _tokenEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            constants.padding,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      right: constants.smallPadding,
                    ),
                    child: Text(
                      constants.logIn,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Image(
                      image: AssetImage(
                        'assets/authillustration.png',
                      ),
                      width: constants.illustrationBigSize,
                      height: constants.illustrationBigSize,
                    ),
                  ),
                ],
              ),
              Form(
                key: _emailFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      readOnly: !_emailEnabled,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        labelText: constants.email,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty
                          ? constants.pleaseEnterAValidEmail
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: constants.padding,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  constants.smallPadding,
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: Center(
                          child: _loading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        right: constants.smallPadding,
                                      ),
                                      child: Text(
                                        constants.pleaseWait,
                                      ),
                                    ),
                                    SizedBox(
                                      width: constants.padding,
                                      height: constants.padding,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.grey.shade600,
                                        ),
                                        strokeWidth:
                                            constants.smallPadding / 4.0,
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  constants.proceed,
                                ),
                        ),
                        onPressed: _emailEnabled
                            ? () async {
                                if (_emailFormKey.currentState!.validate()) {
                                  setState(
                                    () {
                                      _loading = true;
                                      _emailEnabled = false;
                                    },
                                  );
                                  api.ResponseFromEmailAuthentication
                                      responseFromEmailAuthentication =
                                      await api.authenticateEmail(
                                    _emailController.text.toString(),
                                  );
                                  print(
                                      'detail: ${responseFromEmailAuthentication.detail}, email: ${responseFromEmailAuthentication.email?[0]}, status code: ${responseFromEmailAuthentication.statusCode}');
                                  if (responseFromEmailAuthentication
                                          .statusCode ==
                                      200) {
                                    setState(
                                      () {
                                        _loading = false;
                                        _emailEnabled = true;
                                      },
                                    );
                                    _showBottomSheet(context);
                                  } else {
                                    setState(
                                      () {
                                        _loading = false;
                                        _emailEnabled = true;
                                      },
                                    );
                                    String errorDetail =
                                        responseFromEmailAuthentication
                                                .email?[0] ??
                                            constants.authErrorMessage;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          errorDetail,
                                        ),
                                        backgroundColor: Colors.red,
                                        dismissDirection:
                                            DismissDirection.horizontal,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            constants.padding,
          ),
        ),
      ),
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (_, StateSetter setState) => Padding(
          padding: const EdgeInsets.only(
            left: constants.padding,
            right: constants.padding,
            top: constants.padding,
          ),
          child: Form(
            key: _tokenFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tokenController,
                  readOnly: !_tokenEnabled,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.format_list_numbered,
                    ),
                    labelText: constants.token,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? constants.pleaseEnterAValidToken : null,
                ),
                Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: constants.padding,
                      bottom: constants.smallPadding,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                constants.smallPadding,
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Center(
                        child: _processing
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      right: constants.smallPadding,
                                    ),
                                    child: Text(
                                      constants.pleaseWait,
                                    ),
                                  ),
                                  SizedBox(
                                    width: constants.padding,
                                    height: constants.padding,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey.shade600,
                                      ),
                                      strokeWidth: constants.smallPadding / 4.0,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                constants.okay,
                              ),
                      ),
                      onPressed: _tokenEnabled
                          ? () async {
                              if (_tokenFormKey.currentState!.validate()) {
                                setState(
                                  () {
                                    _processing = true;
                                    _tokenEnabled = false;
                                  },
                                );
                                api.ResponseFromTokenAuthentication
                                    responseFromTokenAuthentication =
                                    await api.authenticateToken(
                                  _emailController.text.toString(),
                                  int.parse(_tokenController.text.toString()),
                                );
                                print(
                                    'authorization token: ${responseFromTokenAuthentication.authorizationToken}, otp token: ${responseFromTokenAuthentication.otpToken?[0]}, status code: ${responseFromTokenAuthentication.statusCode}');
                                if (responseFromTokenAuthentication
                                        .statusCode ==
                                    200) {
                                  setState(
                                    () {
                                      //_showBottomSheet = false;
                                      _processing = false;
                                      _tokenEnabled = true;
                                    },
                                  );
                                  /*shared_prefs
                                            .saveUserToken(responseFromTokenAuthentication.authorizationToken);
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');*/
                                } else {
                                  setState(
                                    () {
                                      _processing = false;
                                      _tokenEnabled = true;
                                    },
                                  );
                                  String errorDetail =
                                      responseFromTokenAuthentication
                                              .otpToken?[0] ??
                                          constants.authErrorMessage;
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => AlertDialog(
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.warning,
                                            color: constants.baseColor,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: constants.smallPadding,
                                            ),
                                            child: Text(
                                              constants.oops,
                                              style: TextStyle(
                                                color: constants.baseColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(errorDetail),
                                      actions: [
                                        TextButton(
                                          child: const Text(
                                            constants.okay,
                                          ),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
