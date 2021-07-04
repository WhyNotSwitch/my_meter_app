import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/loading_screen.dart';
import 'utils/constants.dart';
import 'utils/shared_prefs.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _routes,
      theme: ThemeData(
        primaryColor: baseColor,
      ),
    );
  }

  Route? _routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<String?>(
            future: getUserToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else {
                if (snapshot.hasData) {
                  return const HomeScreen();
                } else {
                  return const AuthScreen();
                }
              }
            },
          ),
        );
    }
  }
}
