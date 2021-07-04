import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

class App extends StatelessWidget {
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
          builder: (context) => HomeScreen(),
        );
    }
  }
}
