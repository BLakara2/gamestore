import 'package:flutter/material.dart';
import 'widgets/app_widgets.dart';
import 'pages/profile_page.dart';

void main() => runApp(const DateApp());

class DateApp extends StatelessWidget {
  const DateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sortir avec moi ?',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const ProfilePage(),
    );
  }
}
