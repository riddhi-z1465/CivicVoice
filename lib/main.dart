import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/report_provider.dart';
import 'providers/candidate_provider.dart';
import 'providers/booth_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase backend (civicvoice-c476a)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Seed initial collections if newly created database
    await CivicFirebaseService.seedInitialDataIfEmpty();
  } catch (e) {
    debugPrint('Firebase initialization notice: $e (running with local cache fallback)');
  }

  // Set system UI overlay style to match civic theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CivicVoiceApp());
}

class CivicVoiceApp extends StatelessWidget {
  const CivicVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => CandidateProvider()),
        ChangeNotifierProvider(create: (_) => BoothProvider()),
      ],
      child: MaterialApp(
        title: 'CivicVoice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
