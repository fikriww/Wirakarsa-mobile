import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/initial_test_model.dart';
import '../models/test_result_model.dart';
import '../models/career_simulation_model.dart';
import '../models/mini_project_model.dart';
import '../models/code_review_model.dart';
import '../models/chat_message_model.dart';

class MockDbService {
  Stream<List<InitialTestData>> getInitialTests() {
    return Stream.value([]);
  }

  Stream<List<TestResultData>> getTestResultsForUser(String userId) {
    return Stream.value([]);
  }

  Stream<List<CareerSimulationSession>> getSimulationSessionsForUser(String userId) {
    return Stream.value([]);
  }

  Stream<List<MiniProject>> getMiniProjects() {
    return Stream.value([]);
  }

  Stream<List<CodeReview>> getCodeReviewsForUser(String userId) {
    return Stream.value([]);
  }

  Stream<List<ChatMessage>> getChatMessages(String sessionId) {
    return Stream.value([
      ChatMessage(
        id: '1',
        sessionId: sessionId,
        sender: 'ai',
        text: 'This is a mock response from the AI Mentor since Firebase is removed. Waiting for backend API...',
        timestamp: DateTime.now(),
      )
    ]);
  }
}
