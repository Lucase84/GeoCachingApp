import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/login_page.dart';
import 'package:flutter_application_1/Views/map_page.dart';
import 'package:flutter_application_1/Views/profile_page.dart';
import 'package:flutter_application_1/Views/settings_page.dart';
import 'package:flutter_application_1/color_schemes.g.dart';
import 'package:flutter_application_1/create_geo_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: darkColorScheme,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  final List<Widget> pages = const <Widget>[
    MapPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  List<Widget> _getActionsWidgets() {
    if (currentPage == 0) {
      return <Widget>[
        IconButton(
          icon: Icon(
            Icons.add_location_alt_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const CreateGeoCache(),
              ),
            );
          },
        ),
      ];
    } else {
      return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Geo Cache App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        centerTitle: true,
        actions: _getActionsWidgets(),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: currentPage,
        onTap: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
