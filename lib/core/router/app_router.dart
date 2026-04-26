import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/devhub/presentation/pages/devhub_page.dart';
import '../../features/devhub/presentation/pages/submit_code_page.dart';
import '../../features/devhub/presentation/pages/react_testing_fundamentals_page.dart';
import '../../features/devhub/presentation/pages/css_responsive_mastery_page.dart';
import '../../features/devhub/presentation/pages/react_component_basic_page.dart';
import '../../features/devhub/presentation/pages/async_javascript_mastery_page.dart';
import '../../features/devhub/presentation/pages/submit_react_testing_fundamentals_page.dart';
import '../../features/devhub/presentation/pages/submit_css_responsive_mastery_page.dart';
import '../../features/devhub/presentation/pages/submit_react_component_basic_page.dart';
import '../../features/devhub/presentation/pages/submit_async_javascript_mastery_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // --- Splash & Auth ---
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

      // --- DevHub ---
      GoRoute(
        path: '/devhub',
        builder: (context, state) => const DevhubPage(),
      ),
      GoRoute(
        path: '/devhub/submit-code',
        builder: (context, state) => const SubmitCodePage(),
      ),

      // Project detail pages
      GoRoute(
        path: '/devhub/react-testing-fundamentals',
        builder: (context, state) => const ReactTestingFundamentalsPage(),
      ),
      GoRoute(
        path: '/devhub/css-responsive-mastery',
        builder: (context, state) => const CssResponsiveMasteryPage(),
      ),
      GoRoute(
        path: '/devhub/react-component-basic',
        builder: (context, state) => const ReactComponentBasicPage(),
      ),
      GoRoute(
        path: '/devhub/async-javascript-mastery',
        builder: (context, state) => const AsyncJavascriptMasteryPage(),
      ),

      // Project submit/result pages
      GoRoute(
        path: '/devhub/react-testing-fundamentals/submit',
        builder: (context, state) => const SubmitReactTestingFundamentalsPage(),
      ),
      GoRoute(
        path: '/devhub/css-responsive-mastery/submit',
        builder: (context, state) => const SubmitCssResponsiveMasteryPage(),
      ),
      GoRoute(
        path: '/devhub/react-component-basic/submit',
        builder: (context, state) => const SubmitReactComponentBasicPage(),
      ),
      GoRoute(
        path: '/devhub/async-javascript-mastery/submit',
        builder: (context, state) => const SubmitAsyncJavascriptMasteryPage(),
      ),
    ],
  );
}
