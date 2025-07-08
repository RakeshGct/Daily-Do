import 'package:daily_do/providers/auth_provider.dart';
import 'package:daily_do/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:daily_do/providers/task_provider.dart';
import 'package:daily_do/screens/auth_screen.dart';
import 'package:daily_do/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProxyProvider<AppAuthProvider, TaskProvider>(
          create: (_) => TaskProvider(),
          update: (_, auth, task) => task!..updateUser(auth.user?.uid ?? ''),
        ),
      ],
      child: Consumer<AppAuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            darkTheme: ThemeData.light(),
            title: 'Daily Do',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
