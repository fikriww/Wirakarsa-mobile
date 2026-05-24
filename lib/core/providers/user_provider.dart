import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/mock_db_service.dart';
import '../models/initial_test_model.dart';
import '../models/test_result_model.dart';
import '../models/career_simulation_model.dart';
import '../models/mini_project_model.dart';
import '../models/code_review_model.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService apiService;
  
  AuthNotifier(this.apiService) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final res = await apiService.getMe();
      final user = UserModel.fromMap(res, res['id'].toString());
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  void setUser(UserModel user) {
    state = AsyncValue.data(user);
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    await _init();
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}

final userProfileProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(apiServiceProvider));
});

// Since authStateProvider was used before, we map it to userProfileProvider for backward compatibility
final authStateProvider = Provider<AsyncValue<UserModel?>>((ref) {
  return ref.watch(userProfileProvider);
});

final dbServiceProvider = Provider<MockDbService>((ref) {
  return MockDbService();
});

final initialTestsProvider = StreamProvider<List<InitialTestData>>((ref) {
  return ref.watch(dbServiceProvider).getInitialTests();
});

final userTestResultsProvider = StreamProvider<List<TestResultData>>((ref) {
  final userProfile = ref.watch(userProfileProvider).value;
  if (userProfile == null) return Stream.value([]);
  return ref.watch(dbServiceProvider).getTestResultsForUser(userProfile.uid);
});

final userSimulationSessionsProvider = StreamProvider<List<CareerSimulationSession>>((ref) {
  final userProfile = ref.watch(userProfileProvider).value;
  if (userProfile == null) return Stream.value([]);
  return ref.watch(dbServiceProvider).getSimulationSessionsForUser(userProfile.uid);
});

final miniProjectsProvider = StreamProvider<List<MiniProject>>((ref) {
  return ref.watch(dbServiceProvider).getMiniProjects();
});

final userCodeReviewsProvider = StreamProvider<List<CodeReview>>((ref) {
  final userProfile = ref.watch(userProfileProvider).value;
  if (userProfile == null) return Stream.value([]);
  return ref.watch(dbServiceProvider).getCodeReviewsForUser(userProfile.uid);
});
