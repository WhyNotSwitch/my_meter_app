import 'package:shared_preferences/shared_preferences.dart';

const String keyUserToken = 'keyUserToken';

Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

void saveUserToken(String? token) {
  _sharedPreferences.then(
    (sp) => sp.setString(keyUserToken, token ?? 'null'),
  );
}

Future<String?> getUserToken() async {
  SharedPreferences p = await _sharedPreferences;
  switch (p.getString(keyUserToken)) {
    case 'null':
      return null;
    default:
      return p.getString(keyUserToken);
  }
}
