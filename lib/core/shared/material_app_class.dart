import 'package:flutter/material.dart';

import 'package:p/core/theme/app_theme.dart';
import 'package:p/features/auth/presentation/views/splash_view.dart';
import 'package:p/view_temp/nav_bar.dart';

class MaterialAppClass extends StatelessWidget {
  MaterialAppClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
