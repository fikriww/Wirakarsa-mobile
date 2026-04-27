// File khusus untuk testing halaman tertentu
// Jalankan dengan: flutter run -d chrome -t lib/main_dev.dart
//
// Ganti initialLocation sesuai halaman yang mau ditest:
//   '/simulation'        → Career Simulation (dengan bottom nav)
//   '/home'              → Home (dengan bottom nav)
//   '/sign-in'           → Sign In page
//   '/splash'            → Splash screen
//   '/test-graded/prog'  → Test Graded (Programming)
//   '/test-graded/dtan'  → Test Graded (Data Analysis)
//   '/test-graded/hcev'  → Test Graded (UX Design)
//   '/test-graded/test'  → Test Graded (Testing)
//   '/initial-test/prog' → Initial Test (Programming)
//   '/initial-test/dtan' → Initial Test (Data Analysis)
//   '/initial-test/hcev' → Initial Test (UX Design)
//   '/initial-test/test' → Initial Test (Testing)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/auth/presentation/pages/create_account_page.dart';
import 'features/main/main_shell.dart';
import 'features/initial_test/presentation/pages/test_graded_page.dart';
import 'features/initial_test/domain/entities/mock_test_results.dart';
import 'features/initial_test/presentation/pages/initial_test_page.dart';
import 'features/initial_test/domain/entities/mock_initial_tests.dart';
import 'features/initial_test/presentation/pages/readiness_center_page.dart';

void main() {
  runApp(const DevApp());
}

class DevApp extends StatelessWidget {
  const DevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wirapath - Dev',
      debugShowCheckedModeBanner: true, // banner ON supaya tahu ini mode dev
      theme: AppTheme.lightTheme,
      routerConfig: _devRouter,
    );
  }
}

// ========================================
// GANTI ROUTE DI SINI UNTUK TEST HALAMAN
// ========================================
final _devRouter = GoRouter(
  initialLocation: '/readiness', // ← ganti sesuai kebutuhan
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/create-account',
      builder: (context, state) => const CreateAccountPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainShell(currentIndex: 0),
    ),
    GoRoute(
      path: '/simulation',
      builder: (context, state) => const MainShell(currentIndex: 3),
    ),
    GoRoute(
      path: '/readiness',
      builder: (context, state) => const ReadinessCenterPage(),
    ),
    GoRoute(
      path: '/test-graded/prog',
      builder: (context, state) => TestGradedPage(data: programmingResult),
    ),
    GoRoute(
      path: '/test-graded/dtan',
      builder: (context, state) => TestGradedPage(data: dataAnalysisResult),
    ),
    GoRoute(
      path: '/test-graded/hcev',
      builder: (context, state) => TestGradedPage(data: uxDesignResult),
    ),
    GoRoute(
      path: '/test-graded/test',
      builder: (context, state) => TestGradedPage(data: testingResult),
    ),
    GoRoute(
      path: '/initial-test/prog',
      builder: (context, state) => InitialTestPage(data: programmingTestData),
    ),
    GoRoute(
      path: '/initial-test/dtan',
      builder: (context, state) => InitialTestPage(data: dataAnalysisTestData),
    ),
    GoRoute(
      path: '/initial-test/hcev',
      builder: (context, state) => InitialTestPage(data: uxDesignTestData),
    ),
    GoRoute(
      path: '/initial-test/test',
      builder: (context, state) => InitialTestPage(data: testingTestData),
    ),
  ],
);
