import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_db_service.dart';
import '../models/initial_test_model.dart';
import '../models/test_result_model.dart';
import '../models/career_simulation_model.dart';
import '../models/mini_project_model.dart';
import '../models/code_review_model.dart';

final authServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userProfileProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      
      return FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: FirebaseConfig.databaseId,
      )
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((snapshot) {
            if (!snapshot.exists || snapshot.data() == null) return null;
            return UserModel.fromMap(snapshot.data()!, snapshot.id);
          });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

final dbServiceProvider = Provider<FirebaseDbService>((ref) {
  return FirebaseDbService();
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

