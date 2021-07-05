import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart' as constants;

Future<ResponseFromEmailAuthentication> authenticateEmail(String email) async {
  http.Response response = await http.post(
    Uri.parse(constants.authenticateEmail),
    body: json.encode(
      {
        'email': email,
      },
    ),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  print(
      'response body: ${response.body}, response status code ${response.statusCode}');
  return ResponseFromEmailAuthentication.fromJson(
    statusCode: response.statusCode,
    json: jsonDecode(response.body),
  );
}

class ResponseFromEmailAuthentication {
  int statusCode;
  List<dynamic>? email;
  String? detail;

  ResponseFromEmailAuthentication({
    required this.statusCode,
    required this.email,
    required this.detail,
  });

  factory ResponseFromEmailAuthentication.fromJson({
    required int statusCode,
    required Map<String, dynamic> json,
  }) {
    return ResponseFromEmailAuthentication(
      statusCode: statusCode,
      email: json['email'],
      detail: json['detail'],
    );
  }
}

Future<ResponseFromTokenAuthentication> authenticateToken(
    String email, int token) async {
  http.Response response = await http.post(
    Uri.parse(constants.authenticateToken),
    body: json.encode(
      {
        'email': email,
        'token': token,
      },
    ),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  print(
      'response body: ${response.body}, response status code ${response.statusCode}');
  return ResponseFromTokenAuthentication.fromJson(
    statusCode: response.statusCode,
    json: jsonDecode(response.body),
  );
}

class ResponseFromTokenAuthentication {
  int statusCode;
  List<dynamic>? otpToken;
  String? authorizationToken;

  ResponseFromTokenAuthentication({
    required this.statusCode,
    required this.otpToken,
    required this.authorizationToken,
  });

  factory ResponseFromTokenAuthentication.fromJson({
    required int statusCode,
    required Map<String, dynamic> json,
  }) {
    late List<dynamic>? otpToken;
    late String? authorizationToken;
    if (statusCode == 200) {
      otpToken = null;
      authorizationToken = json['token'];
    } else {
      otpToken = json['token'];
      authorizationToken = null;
    }
    return ResponseFromTokenAuthentication(
      statusCode: statusCode,
      otpToken: otpToken,
      authorizationToken: authorizationToken,
    );
  }
}
