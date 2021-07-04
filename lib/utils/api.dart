import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart' as constants;

Future<Map<String, dynamic>> authenticateEmail(String email) async {
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
  return response.statusCode == 200
      ? {
          'status_code': response.statusCode,
          'detail': jsonDecode(response.body)['detail'],
        }
      : {
          'status_code': response.statusCode,
          'detail': null,
        };
}
