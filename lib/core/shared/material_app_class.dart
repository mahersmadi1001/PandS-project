import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/core/theme/app_theme.dart';
import 'package:p/core/presentation/view_model/theme_bloc.dart';
import 'package:p/features/splash_and_onboarding/presentation/view/splash_view.dart';
import 'package:p/core/shared/nav_bar.dart';

class MaterialAppClass extends StatefulWidget {
  const MaterialAppClass({super.key});

  @override
  State<MaterialAppClass> createState() => _MaterialAppClassState();
}

class _MaterialAppClassState extends State<MaterialAppClass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          theme: themeState is ThemeLoaded
              ? (themeState.isDarkMode
                    ? AppTheme.darkTheme
                    : AppTheme.lightTheme)
              : AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: SplashView(),
        );
      },
    );
  }
}
