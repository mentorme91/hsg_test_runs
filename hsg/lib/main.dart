import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/language_provider.dart';
import 'models/user.dart';
import 'providers/status_provider.dart';
import 'providers/theme_provider.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'wrapper.dart';
// import 'services/notification_service.dart';

String status = 'Student'; // Default status is 'Student'

void main() async {
  // initialize WidgetsFlutterBinding
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app for database manipulations
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  status = await StatusProvider('Student').initializeStatus();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of this application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatusProvider(status),
      child: Builder(builder: (context) {
        return StreamProvider<MyUser?>.value(
          value: AuthService().user(Provider.of<StatusProvider>(context)
              .status), // provides a user stream which tracks updates in our user credentials
          initialData: null,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LanguageProvider()),
              ChangeNotifierProvider(
                create: (context) => MyThemeProvider(),
              ),
            ],
            child: Builder(
              builder: (context) {
                final themeProvider = Provider.of<MyThemeProvider>(context);
                return MaterialApp(
                  theme: themeProvider.theme,
                  darkTheme: themeProvider.theme,
                  locale: _locale,
                  home: const Wrapper(),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
