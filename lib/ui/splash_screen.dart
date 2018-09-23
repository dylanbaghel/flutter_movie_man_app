import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _SplashScreenState();
  }

}

class _SplashScreenState extends State<SplashScreen> {

  Future<Timer> startTimer() async {
    Duration duration = new Duration(seconds: 3);
    return new Timer(duration, () {
      Navigator.of(context).pushReplacementNamed("/MovieApp");
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
        child: new Container(
        decoration: new BoxDecoration(
          color: Colors.brown,
        ),
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 10.0),
              child: new Image.asset(
                "assets/images/app_icon.png",
                width: 200.0,
                height: 200.0,
                )
            ),
            new Text(
              "Welcome To Movie Man App",
              textDirection: TextDirection.ltr,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              )
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: new Text(
                "Find Your Favourite Movie Info",
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic
                )
              )
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: new Column(
                children: <Widget>[
                  new CircularProgressIndicator()
                ],
              )
            )
          ],
        )
      )
    );
  }

}