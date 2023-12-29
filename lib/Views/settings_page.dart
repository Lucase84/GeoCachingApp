import 'package:flutter/material.dart';

/// This class is the widget of the settings page
class SettingsPage extends StatefulWidget {
  /// Constructor for SettingsPage
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Page'),
    );
  }
}
