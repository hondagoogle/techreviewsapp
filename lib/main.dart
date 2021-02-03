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
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'login_screen.dart';
import 'sign_in.dart';
import 'package:quick_actions/quick_actions.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Color(0xff757575),
  ));

  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Color(0xff24527A),
        accentColor: Color(0xff4BBFD4),

        // Define the default font family.
        fontFamily: 'ZachnologyEuclid',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      )));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    signInWithGoogle();
    return MaterialApp();
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

bool _userLoggedIn = false;
String welcometext = "Hey there!";
String firstName = null;

class _HomeState extends State<Home> {
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
  QuickActions quickActions = QuickActions();
  void initState() {
    super.initState();
    _navigate(Widget screen) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }

    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case 'voicemessage':
          return _navigate(VoiceRecorder());
        default:
          return MaterialPageRoute(builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('No Page defined for $shortcutType'),
              ),
            );
          });
      }
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'voicemessage',
        icon: 'ic_shortcut_mic',
        localizedTitle: 'Voice Message',
      ),
      ShortcutItem(
        type: 'latestepisode',
        icon: 'ic_shortcut_headset',
        localizedTitle: 'Latest Episode',
      ),
    ]);
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeWidget(),
    ListenWidget(),
    AboutWidget(),
    SettingsWidget(),
  ];

  final iconList = <IconData>[
    EvaIcons.homeOutline,
    EvaIcons.volumeUpOutline,
    EvaIcons.personOutline,
    EvaIcons.settings2Outline,
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

      floatingActionButton: FloatingActionButton(
        child: Icon(EvaIcons.micOutline, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VoiceRecorder()),
          );
        },
        splashColor: Color(0xff24527A),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Color(0xff757575),
        leftCornerRadius: 25,
        rightCornerRadius: 25,
        height: 70,
        onTap: (index) => setState(() => _currentIndex = index),
        activeColor: Colors.white,
        inactiveColor: Color(0xffc9c9c9),
        splashColor: Colors.white,
        //other params
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
