import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:transparent_image/transparent_image.dart';


import './../utils/utils.dart' as utils;

class Movies extends StatefulWidget {

  final String searchMovie;

  Movies({ Key key, this.searchMovie }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MoviesState();
  }

}

class _MoviesState extends State<Movies> {

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity  = new Connectivity();
  StreamSubscription<ConnectivityResult> _networkSubscription;

  @override
  initState() {
    super.initState();

    _networkSubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        setState(() {});
      }
    });
  }

  void dispose() {
    _networkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.8],
          colors: [
            Color(0x6630E8BF),
            Colors.brown
          ]
        )
      ),
      child: new FutureBuilder(
        future: getMovies(widget.searchMovie),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            if (content.containsKey("Search")) {
              return new ListView.builder(
                itemCount: content["Search"].length,
                itemBuilder: (BuildContext context, int position) {
                  return new ListTile(
                    title: new Text(
                      "${content["Search"][position]["Title"]}",
                      style: new TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: new Text(
                      "Release: ${content["Search"][position]["Year"]}"
                    ),
                    leading: getImage(content["Search"][position]["Poster"], 60.0, 60.0),
                    onTap: () {
                      showMovieDialog(context, content["Search"][position]["imdbID"]);
                    },
                  );
                },
              );
            } else {
              return new Center(
                child: new Text(
                  "No Movies Found",
                  style: new TextStyle(
                    fontSize: 30.0
                  )
                )
              );
            }
          } else {
            return new Center(
                child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new Text(
                      _connectionStatus == ConnectivityResult.none.toString() ? "No Internet": "Getting Movie List"
                    )
                  )
                ],
              )
            );
          }
        },
      )
    );
  }


  Widget getImage(String url, double width, double height) {
    if (url == "N/A") {
      return new Image.asset(
        "assets/images/clouds.png",
        width: width,
        height: height,
      );
    } else {
      return new FadeInImage.memoryNetwork(
       image: "$url",
       placeholder: kTransparentImage,
       width: width,
       height: height,
      );
    }
  }

  void showMovieDialog(BuildContext context, String id) {

    Widget futureBuilder = new FutureBuilder(
      future: getMovie(id),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map movie = snapshot.data;
          if (movie["Response"] == "True") {
            return new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              children: <Widget>[
                getImage(movie["Poster"], 150.0, 150.0),
              
                new ListTile(
                    leading: new Text(
                      "Title: ",
                      style: new TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    title:  new Text(
                    "${movie["Title"]}",
                  )
                ),
                new ListTile(
                  leading: new Text(
                    "Released:",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  title: new Text(
                    "${movie["Released"]}"
                  ),
                ),
                new ListTile(
                  leading: new Text(
                    "Artists:",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  title: new Text(
                    "${movie["Actors"]}"
                  )
                ),
                new ListTile(
                  leading: new Text(
                    "Language:",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  title: new Text(
                    "${movie["Language"]}"
                  )
                ),
                new ListTile(
                  leading: new Text(
                    "Country:",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  title: new Text(
                    "${movie["Country"]}"
                  ),
                ),
                new ListTile(
                  leading: new Text(
                    "Rating:",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  title: new Text(
                    "${movie["imdbRating"]}"
                  )
                ),
                new ListTile(
                  leading: new Text(
                    "Plot: ",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  title: new Text(
                    "${movie["Plot"]}"
                  )
                )
              ],
            );
          } else {
            return new Container();
          }
        } else {
          return new Container(
            alignment: Alignment.center,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new CircularProgressIndicator(),
                new Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: new Text(
                    _connectionStatus == ConnectivityResult.none.toString() ? "No Internet" : "Getting Movie Data"
                  )
                )
              ],
            ),
          );
        }
      },
    );

    AlertDialog movieDialog = new AlertDialog(
      content: futureBuilder,
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "Ok",
            style: new TextStyle(
              color: Colors.white
            )
          ),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ], 
    );

    showDialog(context: context, builder: (context) => movieDialog);
  }

  Future<Map> getMovies(String title) async {
    String apiUrl = "${utils.baseUrl}/?s=${title}&apikey=${utils.apiKey}";
    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Future<Map> getMovie(String id) async {
    String apiUrl = "${utils.baseUrl}/?i=$id&apikey=${utils.apiKey}";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

}