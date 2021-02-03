import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'placeholder_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_unicons/flutter_unicons.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeWidget(),
    ListenWidget(),
  ];

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
      backgroundColor: Colors.white,
      body: _children[_currentIndex], // new

      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Listen to our Podcast",
        onPressed: _launchURL,
        icon: Icon(EvaIcons.micOutline),
        backgroundColor: Color(0xff4BBFD4),
        label: Text(
          "VOICE MESSAGE",
          style: TextStyle(
            fontFamily: "ZachnologyEuclid",
            letterSpacing: 1.2,
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        selectedFontSize: 17,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xffbdbdbd),
        backgroundColor: Color(0xff757575),

        items: [
          BottomNavigationBarItem(
            icon: new Icon(EvaIcons.homeOutline),
            title: new Text(
              'Home',
              style: TextStyle(
                fontFamily: "ZachnologyEuclid",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(EvaIcons.volumeUpOutline),
            title: new Text(
              'Listen',
              style: TextStyle(
                fontFamily: "ZachnologyEuclid",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(EvaIcons.personOutline),
            title: new Text(
              'About Us',
              style: TextStyle(
                fontFamily: "ZachnologyEuclid",
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(EvaIcons.settings2Outline),
            title: new Text(
              'Settings',
              style: TextStyle(
                fontFamily: "ZachnologyEuclid",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Open Url Example',
      home: OpenUrlExample(),
    );
  }
}

class OpenUrlExample extends StatelessWidget {
  const OpenUrlExample({Key key}) : super(key: key);

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
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MyWebView extends StatefulWidget {
  final String title;
  final String selectedUrl;

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Send a Voice Message",
          style: TextStyle(
            fontFamily: "ZachnologyEuclid",
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xff4BBFD4),
        brightness: Brightness.dark,
      ),
      body: Center(
        child: const WebView(
          gestureNavigationEnabled: true,
          initialUrl: 'https://form.jotform.com/210047329927053',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
