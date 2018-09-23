import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './ui/movie_app.dart';
import './ui/splash_screen.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(
        new MaterialApp(
          title: "Movie Man",
          home: new SplashScreen(),
          routes: <String, WidgetBuilder> {
            '/MovieApp': (BuildContext context) => new MovieApp() 
          },
        )
      );
    });
}