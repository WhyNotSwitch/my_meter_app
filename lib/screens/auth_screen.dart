import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;
import '../utils/api.dart' as api;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

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
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        labelText: constants.email,
                        border: OutlineInputBorder(),
                      ),
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
                        child: const Center(
                          child: Text(
                            constants.proceed,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> result =
                                await api.authenticateEmail(
                              _emailController.text.toString(),
                            );
                          }
                        },
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
}
