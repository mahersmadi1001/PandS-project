import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:p/core/config/di.dart';
import 'package:p/core/shared/material_app_class.dart';

import 'package:p/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'uscnnlokapfxozeuxdex',
    anonKey: 'sb_publishable_1sO_oZNgWOF0p4GZh5Mjyw_40Xk8PnK',
  );
  await Hive.initFlutter();
  await Hive.openBox('auth_box');
  await init();
  runApp(
    const PandS(),
  );
}

class PandS extends StatelessWidget {
  const PandS({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(436, 732),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialAppClass(),
    );
  }
}
