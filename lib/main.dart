import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import './utilities/shared_prefs.dart';
import './utilities/ad_util.dart';
import './utilities/firebase_util.dart';
import './utilities/supabase_util.dart';
import './screens/sign_in.dart';
import './providers/my_info.dart';
import './providers/token_data.dart';
import './providers/match_data_from.dart';
import './providers/match_data_to.dart';
import './providers/ranking_data.dart';
import './providers/gem_data.dart';
import './providers/price_data.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'env/.env');
  await SharedPrefs().init();
  initSupabase();
  initFirebase();
  initAdmob();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyInfo()),
        ChangeNotifierProvider(create: (context) => TokenData(context: context)),
        ChangeNotifierProvider(create: (context) => MatchDataFrom(context: context)),
        ChangeNotifierProvider(create: (context) => MatchDataTo(context: context)),
        ChangeNotifierProvider(create: (context) => RankingData()),
        ChangeNotifierProvider(create: (context) => GemData(context: context)),
        ChangeNotifierProvider(create: (context) => PriceData()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ko'),
        ],
        title: 'RoSPagram',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
        ),
        navigatorKey: navigatorKey,
        home: SignIn(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
