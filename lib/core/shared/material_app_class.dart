import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:p/core/theme/app_theme.dart';
import 'package:p/core/presentation/view_model/theme_bloc.dart';
import 'package:p/core/presentation/view_model/language_cubit.dart';
import 'package:p/features/splash_and_onboarding/presentation/view/splash_view.dart';
import 'package:p/core/shared/nav_bar.dart';
import 'dart:ui' as ui;

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
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              theme: themeState is ThemeLoaded
                  ? (themeState.isDarkMode
                        ? AppTheme.darkTheme
                        : AppTheme.lightTheme)
                  : AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: languageState is LanguageLoaded
                  ? languageState.locale
                  : languageState is LanguageChanged
                  ? languageState.locale
                  : const Locale('en'),
              home: SplashView(),
              builder: (context, child) {
                return Directionality(
                  textDirection:
                      (languageState is LanguageLoaded &&
                              languageState.isRTL) ||
                          (languageState is LanguageChanged &&
                              languageState.isRTL)
                      ? ui.TextDirection.rtl
                      : ui.TextDirection.ltr,
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
