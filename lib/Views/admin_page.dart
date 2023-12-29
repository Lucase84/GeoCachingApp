import 'package:flutter/material.dart';
import 'package:flutter_application_1/Routes/authentification.dart';
import 'package:flutter_application_1/Views/admin/geo_caches_management.dart';
import 'package:flutter_application_1/Views/admin/users_management.dart';
import 'package:flutter_application_1/Views/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/State_manager/user_manager.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentPage = 0;
  final List<Widget> pages = const <Widget>[
    GeoCachesManagement(),
    UserManagement(),
  ];

  Future<void> _logOut() async {
    context.read<UserModel>().setUser(null);
    await AuthenticationService().signOut();
    if (context.mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<LoginPage>(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logOut,
          ),
        ],
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'GeoCaches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
