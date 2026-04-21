import 'package:flutter/material.dart';
import 'package:p/core/shared/widgets/onbording.dart';
import 'package:p/core/theme/app_theme.dart';
import 'package:p/features/auth/presentation/views/splash_view.dart';

class MaterialAppClass extends StatelessWidget {
  MaterialAppClass({super.key});
  // ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
