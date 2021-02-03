import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<Post> fetchPost() async {
  final response = await http.get(
      'https://zachnologytechreviews173012.web.app/app-resources/latest-episode-data.json');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

bool _userLoggedIn = false;
String welcometext = "Hey there!";
String firstName = null;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _changeText() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      int firstSpace = name.indexOf(" "); // detect the first space character
      firstName = name.substring(
          0, firstSpace); // get everything upto the first space character
      String lastName = name.substring(firstSpace).trim();
      welcometext = "Hey, $firstName!";
      _userLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 325,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff2e6a9e).withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(30.0),
                    bottomRight: const Radius.circular(30.0)),
                color: Color(0xff24527A),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Image.asset(
                        'assets/logo-transparent-inverted.png',
                        width: 70,
                      )),
                      SizedBox(width: 30),
                      Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "$welcometext",
                              style: TextStyle(
                                fontFamily: "ZachnologyEuclid",
                                letterSpacing: -1,
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Text(
                              "Welcome back",
                              style: TextStyle(
                                fontFamily: "Bungee",
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Latest episode:",
                          style: TextStyle(
                            fontFamily: "ProductSans",
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -70.0, 0.0),
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(15.0),
              width: 330,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                border: Border.all(
                  width: 2.0,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(22.0)),
              ),
              child: InkWell(
                onTap: () {
                  print('hey');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<Post>(
                      future: fetchPost(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Bungee",
                              letterSpacing: 0.5,
                              fontSize: 20,
                              color: Color(0xff24527A),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("Can't load info, no Internet access");
                        }
                        // By default, show a loading spinner
                        return Text(" ");
                      },
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<Post>(
                      future: fetchPost(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.body,
                            style: TextStyle(
                              fontFamily: "ProductSans",
                              letterSpacing: 0.5,
                              fontSize: 20,
                              color: Color(0xff24527A),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text("");
                        }
                        // By default, show a loading spinner
                        return Text(" ");
                      },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                if (_userLoggedIn == false) ...[
                  Text(
                    "Please sign in so we can provide the \nbest experience possible:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xff24527A),
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    splashColor: Colors.grey.withOpacity(0.5),
                    onPressed: () {
                      signInWithGoogle().then((result) {
                        if (result != null) {
                          _changeText();
                        }
                      });
                    },
                    color: Color(0xffDB4437),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage("assets/white-google-logo.png"),
                              height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "ProductSans",
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                if (_userLoggedIn == true) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                        child: Text(
                          "Recommended for $firstName:",
                          style: TextStyle(
                            fontFamily: "ProductSans",
                            fontWeight: FontWeight.bold,
                            color: Color(0xff24527A),
                            letterSpacing: 0.5,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(15.0),
                        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                        width: 150,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(
                            width: 2.0,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(22.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            print('hey');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder<Post>(
                                future: fetchPost(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.title,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: "Bungee",
                                        letterSpacing: 0.5,
                                        fontSize: 17,
                                        color: Color(0xff24527A),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        "Can't load info, no Internet access");
                                  }
                                  // By default, show a loading spinner
                                  return Text(" ");
                                },
                              ),
                              SizedBox(height: 10),
                              FutureBuilder<Post>(
                                future: fetchPost(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.body,
                                      style: TextStyle(
                                        fontFamily: "ProductSans",
                                        letterSpacing: 0.5,
                                        fontSize: 17,
                                        color: Color(0xff24527A),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("");
                                  }
                                  // By default, show a loading spinner
                                  return Text(" ");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(15.0),
                        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                        width: 150,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(
                            width: 2.0,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(22.0)),
                        ),
                        child: InkWell(
                          onTap: () {
                            print('hey');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder<Post>(
                                future: fetchPost(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Bungee",
                                        letterSpacing: 0.5,
                                        fontSize: 17,
                                        color: Color(0xff24527A),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        "Can't load info, no Internet access");
                                  }
                                  // By default, show a loading spinner
                                  return Text(" ");
                                },
                              ),
                              SizedBox(height: 10),
                              FutureBuilder<Post>(
                                future: fetchPost(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data.body,
                                      style: TextStyle(
                                        fontFamily: "ProductSans",
                                        letterSpacing: 0.5,
                                        fontSize: 17,
                                        color: Color(0xff24527A),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text("");
                                  }
                                  // By default, show a loading spinner
                                  return Text(" ");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ListenWidget extends StatelessWidget {
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 20.0,
        shadowColor: Color(0xff24527a),
        title: Text(
          "Listen to our Podcast",
          style: TextStyle(
            fontFamily: "ZachnologyEuclid",
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff24527A),
        brightness: Brightness.dark,
      ),
      body: WebView(
        gestureNavigationEnabled: true,
        initialUrl:
            'https://zachnologytechreviews173012.web.app/app-resources/podcast-player/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  void _changeTextBack() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      welcometext = "Hey there!";
      _userLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 20.0,
        shadowColor: Color(0xff24527a),
        title: Text(
          "App Settings/Info",
          style: TextStyle(
            fontFamily: "ZachnologyEuclid",
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff24527A),
        brightness: Brightness.dark,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Image.asset(
            'assets/fulllogocircle.png',
            height: 120,
          ),
          SizedBox(height: 20),
          Text(
            "Zachnology Tech \nReviews",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "ZachnologyEuclid",
              fontSize: 30,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('App Settings'),
                color: Colors.white,
                splashColor: Colors.grey,
                onLongPress: (AppSettings.openAppSettings),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Color(0xff24527A))),
                onPressed: (AppSettings.openAppSettings),
              ),
              SizedBox(width: 10),
              RaisedButton(
                child: Text('Notification Settings'),
                color: Colors.white,
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Color(0xff24527A))),
                onPressed: (AppSettings.openNotificationSettings),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              if (_userLoggedIn == true) ...[
                OutlineButton(
                  splashColor: Colors.grey,
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "Sign out?",
                          style: TextStyle(
                            fontFamily: 'ZachnologyEuclid',
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        content: Text(
                          "Are you sure you want to sign out?",
                          style: TextStyle(
                            fontFamily: 'ProductSans',
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              signOutGoogle().then((result) {
                                _changeTextBack();
                                Navigator.of(ctx).pop();
                              });
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontFamily: 'ProductSans',
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: 'ProductSans',
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  highlightElevation: 0,
                  borderSide: BorderSide(color: Color(0xff24527A)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Sign out',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "ProductSans",
                              color: Color(0xff24527A),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class AboutWidget extends StatelessWidget {
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 20.0,
        shadowColor: Color(0xff24527a),
        title: Text(
          "Zachnology Tech Reviews",
          style: TextStyle(
            fontFamily: "ZachnologyEuclid",
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff24527A),
        brightness: Brightness.dark,
      ),
      body: Text("settings"),
    );
  }
}

// child: FutureBuilder<Post>(
//                   future: fetchPost(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return Text(
//                         snapshot.data.title,
//                         style: TextStyle(
//                           fontFamily: "Bungee",
//                           letterSpacing: 0.5,
//                           fontSize: 15,
//                           color: Color(0xff24527A),
//                         ),
//                       );
//                     } else if (snapshot.hasError) {
//                       return Text("error");
//                     }

//                     // By default, show a loading spinner
//                     return CircularProgressIndicator();
//                   },
//                 ),

class DividerWidget extends StatefulWidget {
  DividerWidget({Key key}) : super(key: key);

  @override
  _DividerWidgetState createState() => _DividerWidgetState();
}

class _DividerWidgetState extends State<DividerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class VoiceRecorder extends StatefulWidget {
  @override
  _VoiceRecorderState createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 20.0,
        shadowColor: Color(0xff4BBFD4),
        leading: IconButton(
          icon: Icon(EvaIcons.close, color: Colors.white),
          iconSize: 30,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Voice Message",
          style: TextStyle(
            fontFamily: "ZachnologyEuclid",
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xff4BBFD4),
        brightness: Brightness.dark,
      ),
    );
  }
}
