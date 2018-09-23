import 'package:flutter/material.dart';

import './movies_page.dart';
import './../utils/utils.dart' as utils;


class MovieApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MovieAppState();
  }

}

class _MovieAppState extends State<MovieApp> {

  final TextEditingController _searchMovieController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  String _searchMovie = utils.defaultMovie();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldState,
      appBar: new AppBar(
        title:new Text(
          "Movie Man"
        ),
        backgroundColor: Colors.brown,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () { showSearchDialog(context); },
          )
        ],
      ),
      body: new Movies(searchMovie: _searchMovie,),
    );
  }


    void showSearchDialog(BuildContext context) {
    AlertDialog searchDialog = new AlertDialog(
      content: new Center(
        heightFactor: 1.0,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new TextField(
              controller: _searchMovieController,
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                labelText: "Enter Movie"
              ),
            ),
            new FlatButton(
              child: new Text(
                "Search",
                style: new TextStyle(
                  color: Colors.white
                )
              ),
              color: Colors.brown,
              onPressed: () {
                if (_searchMovieController.text != "" && _searchMovieController.text != null) {
                  setState(() {
                    _searchMovie = _searchMovieController.text;
                  });
                  Navigator.pop(context);
                  scaffoldState.currentState.setState(() {});
                } else {

                }
              },
            )
          ],
        )
      ),
    );

    showDialog(context: context, builder: (context) => searchDialog);
  }

}