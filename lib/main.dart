import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'core/config/firebase_config.dart';
import 'app.dart';
import 'core/services/firebase_db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    // Disable persistence for Web to avoid hanging issues
    FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: FirebaseConfig.databaseId,
    ).settings = const Settings(
      persistenceEnabled: false,
    );
  }

  // Seed database with mock data if empty in background
  FirebaseDbService().seedDatabaseIfEmpty().catchError((e) {
    debugPrint('Error seeding database: $e');
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    const ProviderScope(
      child: WirapathApp(),
    ),
  );
}
