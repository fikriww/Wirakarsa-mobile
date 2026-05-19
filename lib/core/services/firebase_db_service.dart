import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_config.dart';
import '../models/user_model.dart';
import '../models/initial_test_model.dart';
import '../models/test_result_model.dart';
import '../models/career_simulation_model.dart';
import '../models/chat_message_model.dart';
import '../models/mini_project_model.dart';
import '../models/code_review_model.dart';

class FirebaseDbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: FirebaseConfig.databaseId,
  );

  // ----------------------------------------------------
  // Database Seeding Logic
  // ----------------------------------------------------

  /// Seeds initial_tests and mini_projects collections if they are empty
  Future<void> seedDatabaseIfEmpty() async {
    try {
      // 1. Seed Initial Tests
      final testsSnap = await _firestore.collection('initial_tests').limit(1).get();
      if (testsSnap.docs.isEmpty) {
        debugPrint('Seeding initial_tests collection in Firestore...');
        final tests = _getInitialTestsSeedData();
        for (final test in tests) {
          await _firestore.collection('initial_tests').doc(test.id).set(test.toMap());
        }
        debugPrint('initial_tests seeded successfully.');
      }

      // 2. Seed Mini Projects
      final projectsSnap = await _firestore.collection('mini_projects').limit(1).get();
      if (projectsSnap.docs.isEmpty) {
        debugPrint('Seeding mini_projects collection in Firestore...');
        final projects = _getMiniProjectsSeedData();
        for (final project in projects) {
          await _firestore.collection('mini_projects').doc(project.id).set(project.toMap());
        }
        debugPrint('mini_projects seeded successfully.');
      }
    } catch (e) {
      debugPrint('Error seeding database: $e');
    }
  }

  // ----------------------------------------------------
  // User Profile
  // ----------------------------------------------------

  /// Fetches a UserModel by UID
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  /// Updates a user profile with new data
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          ...data,
          'lastActive': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      rethrow;
    }
  }

  // ----------------------------------------------------
  // Initial Competency Tests
  // ----------------------------------------------------

  /// Stream of initial tests definitions
  Stream<List<InitialTestData>> getInitialTests() {
    return _firestore.collection('initial_tests').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => InitialTestData.fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// Saves a competency test result for a user
  Future<void> saveTestResult(TestResultData result) async {
    try {
      final docRef = result.id.isEmpty
          ? _firestore.collection('test_results').doc()
          : _firestore.collection('test_results').doc(result.id);
      
      await docRef.set({
        ...result.toMap(),
        'submittedDate': FieldValue.serverTimestamp(),
      });
      debugPrint('Test result saved successfully with ID: ${docRef.id}');
    } catch (e) {
      debugPrint('Error saving test result: $e');
      rethrow;
    }
  }

  /// Stream of test results for a specific user
  Stream<List<TestResultData>> getTestResultsForUser(String userId) {
    return _firestore
        .collection('test_results')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TestResultData.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ----------------------------------------------------
  // Career Simulation
  // ----------------------------------------------------

  /// Creates a new CareerSimulationSession and returns its ID
  Future<String> createSimulationSession(CareerSimulationSession session) async {
    try {
      final docRef = _firestore.collection('career_simulation_sessions').doc();
      await docRef.set({
        ...session.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating simulation session: $e');
      rethrow;
    }
  }

  /// Updates simulation session status
  Future<void> updateSimulationSessionStatus(String sessionId, String status) async {
    try {
      await _firestore.collection('career_simulation_sessions').doc(sessionId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating simulation session status: $e');
      rethrow;
    }
  }

  /// Stream of career simulation sessions for a specific user
  Stream<List<CareerSimulationSession>> getSimulationSessionsForUser(String userId) {
    return _firestore
        .collection('career_simulation_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CareerSimulationSession.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Adds a chat message in the messages subcollection under a session
  Future<void> addChatMessage(String sessionId, ChatMessage message) async {
    try {
      final docRef = _firestore
          .collection('career_simulation_sessions')
          .doc(sessionId)
          .collection('messages')
          .doc();
      
      await docRef.set({
        ...message.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update parent session's updatedAt time
      await _firestore.collection('career_simulation_sessions').doc(sessionId).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding chat message: $e');
      rethrow;
    }
  }

  /// Stream of chat messages for a specific session
  Stream<List<ChatMessage>> getChatMessages(String sessionId) {
    return _firestore
        .collection('career_simulation_sessions')
        .doc(sessionId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ----------------------------------------------------
  // Mini Projects & Code Reviews
  // ----------------------------------------------------

  /// Stream of mini projects definitions
  Stream<List<MiniProject>> getMiniProjects() {
    return _firestore.collection('mini_projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MiniProject.fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// Saves / submits a CodeReview
  Future<void> submitCodeReview(CodeReview review) async {
    try {
      final docRef = review.id.isEmpty
          ? _firestore.collection('code_reviews').doc()
          : _firestore.collection('code_reviews').doc(review.id);
      
      await docRef.set({
        ...review.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update user's progress of that mini project
      // For simplicity, we also update the mini_projects progress or mock update in users profile
    } catch (e) {
      debugPrint('Error submitting code review: $e');
      rethrow;
    }
  }

  /// Stream of code reviews for a specific user
  Stream<List<CodeReview>> getCodeReviewsForUser(String userId) {
    return _firestore
        .collection('code_reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CodeReview.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ----------------------------------------------------
  // Private Seed Data Generators
  // ----------------------------------------------------

  List<InitialTestData> _getInitialTestsSeedData() {
    return [
      InitialTestData(
        id: 'prog',
        testTitle: 'Programming /\nSoftware Development',
        testSubtitle: 'Multiple Choice · 5 questions',
        badgeText: 'PROG',
        badgeColorHex: '0xFFFFF3CD',
        badgeTextColorHex: '0xFF856404',
        questions: [
          TestQuestion(
            questionText: 'Which data structure uses LIFO (Last In, First Out) order?',
            options: [
              QuestionOption(text: 'Queue', isCorrect: false),
              QuestionOption(text: 'Stack', isCorrect: true),
              QuestionOption(text: 'Linked List', isCorrect: false),
              QuestionOption(text: 'Tree', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'Which HTTP method is idempotent and used to fully update a resource?',
            options: [
              QuestionOption(text: 'POST', isCorrect: false),
              QuestionOption(text: 'PATCH', isCorrect: false),
              QuestionOption(text: 'PUT', isCorrect: true),
              QuestionOption(text: 'DELETE', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'What is tail recursion?',
            options: [
              QuestionOption(text: 'Recursion that never terminates', isCorrect: false),
              QuestionOption(text: 'Recursion where the recursive call is the last operation', isCorrect: true),
              QuestionOption(text: 'A loop disguised as recursion', isCorrect: false),
              QuestionOption(text: 'Recursion with two base cases', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'Which testing approach tests a module in isolation with mocked dependencies?',
            options: [
              QuestionOption(text: 'Integration testing', isCorrect: false),
              QuestionOption(text: 'End-to-end testing', isCorrect: false),
              QuestionOption(text: 'Unit testing', isCorrect: true),
              QuestionOption(text: 'Smoke testing', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'What is eventual consistency in distributed systems?',
            options: [
              QuestionOption(text: 'All nodes are always in sync', isCorrect: false),
              QuestionOption(text: 'A transaction rollback mechanism', isCorrect: false),
              QuestionOption(text: 'A replication strategy', isCorrect: false),
              QuestionOption(text: 'Data updates propagate to all nodes over time, not instantly', isCorrect: true),
            ],
          ),
        ],
      ),
      InitialTestData(
        id: 'dtan',
        testTitle: 'Data Analysis',
        testSubtitle: 'File Upload + Short Essay',
        badgeText: 'DTAN',
        badgeColorHex: '0xFFFFE8CC',
        badgeTextColorHex: '0xFF8B5E00',
        practicalTaskDescription:
            'You are given a retail sales dataset (sales_dataset) containing columns: date, product_id, category, region, units_sold, unit_price, discount_customer_segment.\n\n'
            'Complete the following in a Jupyter Notebook or Excel and upload your file:\n\n'
            '1. Clean the dataset — identify and handle missing values, duplicates, and outliers. Document your approach.\n'
            '2. Calculate total revenue per category per month. Which category performed best in Q1?\n'
            '3. Compute the average discount rate per customer segment. Does higher discount correlate with higher unit sales?\n'
            '4. Identify the top 5 products by revenue in the "tech" region.\n'
            '5. Create at least 2 visualizations: one showing monthly revenue trend, one showing category breakdown by region.\n'
            '6. Build a simple linear regression model to predict unit_sold based on unit_price and discount. Report R² and interpret the result.',
        uploadFields: [
          UploadField(
            label: 'Upload The Analysis Results',
            supportedFormats: 'Supports only .xlsx (Max 10 MB)',
          ),
        ],
        essayFields: [
          EssayField(
            label: 'Interpretation Essay',
            placeholder: 'Based on the analysis above, answer the following in 150-250 words:\n\n'
                '• What is the most significant business insight you found?\n'
                '• Which customer segment should the company prioritize, and why?\n'
                '• What are the limitations of your analysis, and what additional data would improve it?',
          ),
          EssayField(
            label: 'Interpretation of Results',
            placeholder: 'Write the main insights from your analysis.',
          ),
        ],
      ),
      InitialTestData(
        id: 'hcev',
        testTitle: 'User Experience Design',
        testSubtitle: 'Design Brief + Portfolio Upload',
        badgeText: 'HCEV',
        badgeColorHex: '0xFFD4EDDA',
        badgeTextColorHex: '0xFF155724',
        practicalTaskDescription:
            'You are a UX designer at a fintech startup launching a personal finance app targeting young professionals aged 22-35. The product team has identified a key problem: users abandon the app within the first week because the onboarding feels overwhelming and they don\'t understand the app\'s core value.\n\n'
            'Your task:\n\n'
            'Design the onboarding experience for this app. Your submission must include:\n\n'
            '1. User persona — define one target user (name, age, goals, pain points, tech comfort level).\n'
            '2. User flow — map out the full onboarding journey from app launch to first meaningful action (e.g., connecting a bank account or setting a budget goal). Minimum 6 steps.\n'
            '3. Wireframes — low or mid-fidelity screens for at least 5 key screens in the onboarding flow.\n'
            '4. Prototype — a clickable prototype (Figma preferred) demonstrating the primary onboarding path.\n'
            '5. Design rationale — a written section (100-150 words) explaining your key design decisions, especially how you addressed the abandonment problem.\n\n'
            'Evaluation criteria: Clarity of user flow, visual hierarchy, accessibility considerations, quality of rationale.\n\n'
            'Upload your complete work as a .fig, .pdf report, or .zip containing all assets.',
        uploadFields: [
          UploadField(
            label: 'Upload Mockup or Prototype',
            supportedFormats: 'Supports .fig, .pdf, .zip (Max 10 MB)',
          ),
        ],
      ),
      InitialTestData(
        id: 'test',
        testTitle: 'Testing',
        testSubtitle: 'Multiple Choice · 5 questions',
        badgeText: 'TEST',
        badgeColorHex: '0xFFDBEAFE',
        badgeTextColorHex: '0xFF1E40AF',
        questions: [
          TestQuestion(
            questionText: 'What is a flaky test?',
            options: [
              QuestionOption(text: 'A test with no assertions', isCorrect: false),
              QuestionOption(text: 'A skipped test', isCorrect: false),
              QuestionOption(text: 'A test that passes and fails intermittently without code changes', isCorrect: true),
              QuestionOption(text: 'A test with too many assertions', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'Which tool is primarily used for API testing?',
            options: [
              QuestionOption(text: 'Selenium', isCorrect: false),
              QuestionOption(text: 'Postman', isCorrect: true),
              QuestionOption(text: 'Jest', isCorrect: false),
              QuestionOption(text: 'Playwright', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'What does "boundary value analysis" mean?',
            options: [
              QuestionOption(text: 'Testing only the center of input ranges', isCorrect: false),
              QuestionOption(text: 'Testing at the edges of input ranges', isCorrect: true),
              QuestionOption(text: 'Skipping boundary checks', isCorrect: false),
              QuestionOption(text: 'Boundary is only for UI testing', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'What is a test suite?',
            options: [
              QuestionOption(text: 'A single test', isCorrect: false),
              QuestionOption(text: 'A bug report', isCorrect: false),
              QuestionOption(text: 'A structured set of conditions, steps, and expected results to verify a feature', isCorrect: true),
              QuestionOption(text: 'An alternative name for production code', isCorrect: false),
            ],
          ),
          TestQuestion(
            questionText: 'In the testing pyramid, which layer should have the most tests?',
            options: [
              QuestionOption(text: 'UI', isCorrect: false),
              QuestionOption(text: 'Integration', isCorrect: false),
              QuestionOption(text: 'Unit', isCorrect: true),
              QuestionOption(text: 'Manual', isCorrect: false),
            ],
          ),
        ],
        practicalTaskDescription:
            'Using the following test story, write a complete test case document for a "Password Reset" feature:\n\n'
            'The user clicks "Forgot Password", enters their email, receives a reset link, clicks the link, creates a new password (min 8 chars, 1 uppercase, 1 number), and is redirected to login. Consider edge cases: expired link, invalid email, password mismatch, and already-used link.',
        uploadFields: [
          UploadField(
            label: 'Upload Test Case Document',
            supportedFormats: 'Supports only .xlsx (Max 10 MB)',
          ),
        ],
      ),
    ];
  }

  List<MiniProject> _getMiniProjectsSeedData() {
    return [
      MiniProject(
        id: 'react_testing_fundamentals',
        title: 'React Testing Fundamentals',
        description: 'Build a complete checkout form using TDD approach with Jest & React Testing Library.',
        gap: 'Skill Gap: 78%',
        tags: ['Intermediate', '6 hrs', '4 variants'],
        progress: 0.3,
      ),
      MiniProject(
        id: 'css_responsive_mastery',
        title: 'CSS Responsive Mastery',
        description: 'Build a fully accessible UI component library following WCAG 2.1 AA.',
        gap: 'Skill Gap: 15%',
        tags: ['Intermediate', '4 hrs', '3 variants'],
        progress: 0.9,
      ),
      MiniProject(
        id: 'react_component_basic',
        title: 'React Component Basic',
        description: 'Build responsive landing page including a navbar, hero section, and call-to-action.',
        gap: 'Skill Gap: 48%',
        tags: ['Intermediate', '4 hrs', '4 variants'],
        progress: 0.85,
      ),
      MiniProject(
        id: 'async_javascript_mastery',
        title: 'Async JavaScript Mastery',
        description: 'Master asynchronous JavaScript to handle tasks like API calls and timers.',
        gap: 'Skill Gap: 25%',
        tags: ['Intermediate', '6 hrs', '3 variants'],
        progress: 0.74,
      ),
    ];
  }
}
