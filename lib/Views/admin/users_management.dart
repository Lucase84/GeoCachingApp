import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Objects/user.dart';
import 'package:flutter_application_1/Routes/user.dart';
import 'package:http/http.dart' as http;

/// This class is used to manage the users (delete, get) in the admin view
class UserManagement extends StatefulWidget {
  /// Constructor for UserManagement
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  List<UserData> _users = <UserData>[];

  @override
  void initState() {
    super.initState();
    unawaited(_fetchUsers());
  }

  Future<void> _fetchUsers() async {
    final List<UserData> users = await UserManager().getUsers();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(_users[index].email),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final http.Response res =
                  await UserManager().deleteUser(_users[index].id);
              if (res.statusCode == 200 && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('GeoCache deleted'),
                  ),
                );
              } else if (res.statusCode == 403 && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You cannot delete yourself'),
                  ),
                );
              }
              await _fetchUsers();
            },
          ),
        );
      },
    );
  }
}
