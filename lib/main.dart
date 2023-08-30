import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './utilities/shared_prefs.dart';
import './utilities/supabase_util.dart';
import './screens/sign_in.dart';
import './providers/my_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  initSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyInfo(),
      child: MaterialApp(
        title: 'RoSPagram',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
        ),
        home: SignIn(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
