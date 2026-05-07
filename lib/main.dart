import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:p/core/config/di.dart';
import 'package:p/core/shared/material_app_class.dart';
import 'package:p/features/auth/presentation/view_model/Register_bloc/register_bloc.dart';
import 'package:p/features/auth/presentation/view_model/login_bloc/login_bloc.dart';
import 'package:p/features/auth/presentation/view_model/user_session/user_session_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/create_post/create_post_bloc.dart';
import 'package:p/features/create_and_view_post/presentation/view_model/get_post/get_posts_bloc.dart';
import 'package:p/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:p/core/presentation/bloc/theme_bloc.dart';
import 'package:p/features/history/presentation/view_model/history_bloc.dart';

import 'package:p/firebase_options.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://uscnnlokapfxozeuxdex.supabase.co',
    anonKey: 'sb_publishable_1sO_oZNgWOF0p4GZh5Mjyw_40Xk8PnK',
  );
  await Hive.initFlutter();
  await Hive.openBox('auth_box');
  await Hive.openBox('theme_box');
  await init();
  runApp(const PandS());
}

class PandS extends StatelessWidget {
  const PandS({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(436, 732),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LoginBloc>()),
          BlocProvider(create: (_) => sl<RegisterBloc>()),
          BlocProvider(create: (_) => sl<UserSessionBloc>()),
          BlocProvider(create: (_) => sl<CreatePostBloc>()),
          BlocProvider(create: (_) => sl<ProfileBloc>()),
          BlocProvider(create: (_) => sl<HistoryBloc>()),
          BlocProvider(create: (_) => ThemeBloc()),
        ],

        child: MaterialAppClass(),
      ),
    );
  }
}
