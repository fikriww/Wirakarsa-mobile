import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/assessment/presentation/pages/assessment_page.dart';
import '../../features/assessment/presentation/pages/connect_github_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/readiness/presentation/pages/readiness_center_page.dart';
import '../../features/readiness/presentation/pages/cv_screening_page.dart';
import '../../features/readiness/presentation/pages/cv_screening_result_page.dart';
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
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/personal_information_page.dart';
import '../../features/profile/presentation/pages/password_security_page.dart';
import '../../features/profile/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/language_appearance_page.dart';
import '../../features/profile/presentation/pages/integrations_page.dart';
import '../../features/profile/presentation/pages/help_support_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // --- Splash, Onboarding & Auth ---
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
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
        path: '/assessment',
        builder: (context, state) => const AssessmentPage(),
      ),
      GoRoute(
        path: '/connect-github',
        builder: (context, state) => const ConnectGithubPage(),
      ),

      // --- Main Tabs ---
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/readiness-center',
        builder: (context, state) => const ReadinessCenterPage(),
      ),

      GoRoute(
        path: '/cv-screening',
        builder: (context, state) => const CvScreeningPage(),
      ),
      GoRoute(
        path: '/cv-screening-result',
        builder: (context, state) => const CvScreeningResultPage(),
      ),

      // --- DevHub ---
      GoRoute(path: '/devhub', builder: (context, state) => const DevhubPage()),
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

      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/personal-information',
        builder: (context, state) => const PersonalInformationPage(),
      ),
      GoRoute(
        path: '/password-security',
        builder: (context, state) => const PasswordSecurityPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/language-appearance',
        builder: (context, state) => const LanguageAppearancePage(),
      ),
      GoRoute(
        path: '/integrations',
        builder: (context, state) => const IntegrationsPage(),
      ),
      GoRoute(
        path: '/help-support',
        builder: (context, state) => const HelpSupportPage(),
      ),
    ],
  );
}
