import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  // --- AUTHENTICATION ---

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred during sign in.';
    }
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred during account creation.';
    }
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  static Future<bool> linkGitHub() async {
    try {
      if (currentUser == null) {
        // Not authenticated: sign in with GitHub instead of linking
        final success = await client.auth.signInWithOAuth(
          OAuthProvider.github,
          redirectTo: 'io.supabase.wirapath://login-callback/',
        );
        return success;
      } else {
        // Authenticated: link GitHub to the current account
        final success = await client.auth.linkIdentity(
          OAuthProvider.github,
          redirectTo: 'io.supabase.wirapath://login-callback/',
        );
        return success;
      }
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Failed to connect GitHub account: $e';
    }
  }

  static String? getConnectedGitHubUsername() {
    final user = currentUser;
    if (user == null) return null;
    
    final identities = user.identities;
    if (identities == null) return null;
    
    for (final identity in identities) {
      if (identity.provider.toLowerCase() == 'github') {
        final data = identity.identityData;
        if (data != null) {
          return data['user_name'] ?? data['preferred_username'] ?? 'Connected';
        }
      }
    }
    return null;
  }

  // --- DATA FETCHING (Matching optimized schema) ---

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await client
        .from('test_categories')
        .select('*')
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getTests(String categoryId) async {
    final response = await client
        .from('tests')
        .select('*')
        .eq('category_id', categoryId)
        .eq('is_active', true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getQuestions(String testId) async {
    final response = await client
        .from('test_questions')
        .select('*, test_question_options(*)')
        .eq('test_id', testId)
        .order('order_index', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createSubmission({
    required String testId,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) throw 'User not authenticated';

    final response = await client.from('test_submissions').insert({
      'user_id': userId,
      'test_id': testId,
      'status': 'pending',
    }).select().single();
    
    return response;
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    final userId = currentUser?.id;
    if (userId == null) return null;

    final response = await client
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  static Future<List<Map<String, dynamic>>> getInitialTests() async {
    final response = await client
        .from('tests')
        .select('*, test_categories(name, badge_color, badge_text, badge_text_color)')
        .eq('is_active', true)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getUserSubmissions() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    final response = await client
        .from('test_submissions')
        .select('*, tests(id, title)')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> submitAnswer({
    required String submissionId,
    required String questionId,
    String? selectedOptionId,
    String? essayAnswer,
    String? fileUrl,
  }) async {
    await client.from('submission_answers').insert({
      'submission_id': submissionId,
      'question_id': questionId,
      'selected_option_id': selectedOptionId,
      'essay_answer': essayAnswer,
      'file_url': fileUrl,
    });
  }

  static Future<Map<String, dynamic>?> getResult(String submissionId) async {
    final response = await client
        .from('test_results')
        .select('*, result_metrics(*), result_issues(*)')
        .eq('submission_id', submissionId)
        .maybeSingle();
    return response;
  }
}
