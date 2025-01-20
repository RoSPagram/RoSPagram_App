import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import './utilities/shared_prefs.dart';
import './utilities/ad_util.dart';
import './utilities/firebase_util.dart';
import './utilities/supabase_util.dart';
import './utilities/version_check.dart';
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
        home: FutureBuilder(
          future: checkAppVersion(context),
          builder: (context, snapshot) {
            final localText = AppLocalizations.of(context)!;
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 로딩 상태
              return Scaffold(
                body: Center(child: LinearProgressIndicator(color: Colors.black12)),
              );
            }

            if (snapshot.hasError) {
              // 오류 상태
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              // 업데이트가 필요한 경우
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localText.update_required,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Color(0xff000000), foregroundColor: Color(0xffffffff)),
                        onPressed: () async {
                          if (await canLaunchUrlString(snapshot.data!)) {
                            await launchUrlString(snapshot.data!);
                          }
                        },
                        child: Text(localText.update),
                      ),
                    ],
                  ),
                ),
              );
            }

            // 업데이트가 필요하지 않은 경우
            return SignIn();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
