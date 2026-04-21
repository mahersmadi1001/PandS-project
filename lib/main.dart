import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:p/core/shared/material_app_class.dart';
import 'package:p/core/shared/widgets/onbording.dart';
import 'package:p/core/theme/app_theme.dart';
import 'package:p/features/auth/presentation/views/splash_view.dart';
import 'package:p/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'uscnnlokapfxozeuxdex',
    anonKey: 'sb_publishable_1sO_oZNgWOF0p4GZh5Mjyw_40Xk8PnK',
  );

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
      builder: (context, child) => MaterialAppClass(),
    );
  }
}
 