import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../features/simulation/data/models/jobdesk_analysis_result.dart';

class ApiService {
  // Use localhost for Web/iOS, and 10.0.2.2 for Android Emulator.
  static final String baseUrl = kIsWeb ? 'http://localhost:5001' : (defaultTargetPlatform == TargetPlatform.android ? 'http://10.0.2.2:5001' : 'http://localhost:5001');

  // In-memory storage for JWT cookies and tokens
  static String? _cookieHeader;
  static String? _accessToken;
  static String? _refreshToken;

  /// Helper for API requests headers
  Map<String, String> _getHeaders() {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (_cookieHeader != null) {
      headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    debugPrint('ApiService Headers: $headers');
    return headers;
  }

  /// Analyze a job description against the user's profile via the backend
  /// (`POST /api/jobdesk/analyze`). Mirrors the web `analyzeJobDescription`,
  /// so mobile and web share the same backend/LLM pipeline.
  Future<JobdeskAnalysisResult> analyzeJobDescription(String jobDescription) async {
    final url = Uri.parse('$baseUrl/api/jobdesk/analyze');
    debugPrint('API POST -> $url');
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({'job_description': jobDescription}),
      );
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final result = decoded['result'] ?? decoded;
        return JobdeskAnalysisResult.fromJson(
          Map<String, dynamic>.from(result as Map),
        );
      } else {
        throw Exception(
          decoded['message'] ?? 'Failed to analyze job description.',
        );
      }
    } catch (e) {
      debugPrint('AnalyzeJobDescription API Error: $e');
      rethrow;
    }
  }

  /// Register a new account
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    debugPrint('API POST -> $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 201) {
        _updateCookie(response);
        if (decoded['result'] != null && decoded['result']['tokens'] != null) {
          _accessToken = decoded['result']['tokens']['accessToken'];
          _refreshToken = decoded['result']['tokens']['refreshToken'];
        }
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to register account.');
      }
    } catch (e) {
      debugPrint('Registration API Error: $e');
      rethrow;
    }
  }

  /// Login with email or username
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    debugPrint('API POST -> $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': email.trim(),
          'password': password,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _updateCookie(response);
        if (decoded['result'] != null && decoded['result']['tokens'] != null) {
          _accessToken = decoded['result']['tokens']['accessToken'];
          _refreshToken = decoded['result']['tokens']['refreshToken'];
        }
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Incorrect email or password.');
      }
    } catch (e) {
      debugPrint('Login API Error: $e');
      rethrow;
    }
  }

  /// Login or Register with Google OAuth
  Future<Map<String, dynamic>> googleAuth({
    required String idToken,
    bool isSignUp = false,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/google');
    debugPrint('API POST -> $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': idToken,
          'isSignUp': isSignUp,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _updateCookie(response);
        if (decoded['result'] != null && decoded['result']['tokens'] != null) {
          _accessToken = decoded['result']['tokens']['accessToken'];
          _refreshToken = decoded['result']['tokens']['refreshToken'];
        }
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to authenticate with Google.');
      }
    } catch (e) {
      debugPrint('Google Auth API Error: $e');
      rethrow;
    }
  }

  /// Refresh Session Tokens
  Future<Map<String, dynamic>> refreshTokens() async {
    final url = Uri.parse('$baseUrl/api/auth/refresh');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          if (_refreshToken != null) 'refreshToken': _refreshToken,
        }),
      );
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _updateCookie(response);
        if (decoded['result'] != null && decoded['result']['tokens'] != null) {
          _accessToken = decoded['result']['tokens']['accessToken'];
          _refreshToken = decoded['result']['tokens']['refreshToken'];
        }
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to refresh tokens. Please login again.');
      }
    } catch (e) {
      debugPrint('Refresh Token API Error: $e');
      rethrow;
    }
  }

  /// Get current session user profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/api/auth/me');
    debugPrint('API GET -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Session expired or unauthorized.');
      }
    } catch (e) {
      debugPrint('GetCurrentUser API Error: $e');
      rethrow;
    }
  }

  /// Update Onboarding Profile (Names, University, etc)
  Future<Map<String, dynamic>> updateOnboardingProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String university,
    required String fieldOfStudy,
    required String graduationYear,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/onboarding/profile');
    debugPrint('API PATCH -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'university': university,
          'field_of_study': fieldOfStudy,
          'graduation_year': int.tryParse(graduationYear) ?? 0,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to update profile.');
      }
    } catch (e) {
      debugPrint('UpdateOnboardingProfile API Error: $e');
      rethrow;
    }
  }

  /// Complete onboarding goal step
  Future<Map<String, dynamic>> updateOnboardingGoal({
    required String userId,
    required String goal,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/onboarding/goal');
    debugPrint('API PATCH -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({'achievement_goal': goal}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to update goal.');
      }
    } catch (e) {
      debugPrint('UpdateOnboardingGoal API Error: $e');
      rethrow;
    }
  }

  /// Complete onboarding role step
  Future<Map<String, dynamic>> updateOnboardingRole({
    required String userId,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/onboarding/role');
    debugPrint('API PATCH -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({'target_role': role}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to update target role.');
      }
    } catch (e) {
      debugPrint('UpdateOnboardingRole API Error: $e');
      rethrow;
    }
  }

  /// Helper to upload files via Multipart
  Future<Map<String, dynamic>> _uploadMultipart({
    required String path,
    required String fileKey,
    required String filePath,
    required String fileName,
  }) async {
    final url = Uri.parse('$baseUrl$path');
    debugPrint('API PATCH MULTIPART -> $url');

    final request = http.MultipartRequest('PATCH', url);

    if (_cookieHeader != null) {
      request.headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }

    final file = await http.MultipartFile.fromPath(fileKey, filePath, filename: fileName);
    request.files.add(file);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to upload document.');
      }
    } catch (e) {
      debugPrint('Multipart Upload Error: $e');
      rethrow;
    }
  }

  /// Upload onboarding CV file
  Future<Map<String, dynamic>> uploadOnboardingCv({
    required String userId,
    required String cvPath,
    required String cvName,
  }) async {
    return _uploadMultipart(
      path: '/api/users/$userId/onboarding/cv',
      fileKey: 'cv',
      filePath: cvPath,
      fileName: cvName,
    );
  }

  /// Upload onboarding Transcript file
  Future<Map<String, dynamic>> uploadOnboardingTranscript({
    required String userId,
    required String transcriptPath,
    required String transcriptName,
  }) async {
    return _uploadMultipart(
      path: '/api/users/$userId/onboarding/transcript',
      fileKey: 'transcript',
      filePath: transcriptPath,
      fileName: transcriptName,
    );
  }

  /// Complete Onboarding Status
  Future<Map<String, dynamic>> completeOnboarding({
    required String userId,
    String? githubId,
    String? githubUsername,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/onboarding/complete');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          if (githubId != null) 'githubId': githubId,
          if (githubUsername != null) 'githubUsername': githubUsername,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to complete onboarding.');
      }
    } catch (e) {
      debugPrint('CompleteOnboarding API Error: $e');
      rethrow;
    }
  }

  /// Update Account Settings
  Future<Map<String, dynamic>> updateProfileSettings({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String university,
    String? fieldOfStudy,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/profile');
    debugPrint('API PATCH -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'university': university,
          if (fieldOfStudy != null) 'field_of_study': fieldOfStudy,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to update account settings.');
      }
    } catch (e) {
      debugPrint('UpdateProfileSettings API Error: $e');
      rethrow;
    }
  }

  /// Get a user's full profile by id.
  /// Returns the user object including `github_username` and linked `providers`.
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId');
    debugPrint('API GET -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(decoded['result'] ?? decoded);
      } else {
        throw Exception(decoded['message'] ?? 'Failed to load user profile.');
      }
    } catch (e) {
      debugPrint('GetUserProfile API Error: $e');
      rethrow;
    }
  }

  /// Connect / sync a GitHub account by username.
  /// Calls POST /api/users/:id/github/sync which links the username, fetches the
  /// account's public repositories and recomputes the readiness score.
  Future<Map<String, dynamic>> connectGithub({
    required String userId,
    required String githubUsername,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/github/sync');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'githubUsername': githubUsername}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(decoded['result'] ?? decoded);
      } else {
        throw Exception(
            decoded['message'] ?? 'Failed to connect GitHub account.');
      }
    } catch (e) {
      debugPrint('ConnectGithub API Error: $e');
      rethrow;
    }
  }

  /// Update Password
  Future<Map<String, dynamic>> updatePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/password');
    debugPrint('API PUT -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to update password.');
      }
    } catch (e) {
      debugPrint('UpdatePassword API Error: $e');
      rethrow;
    }
  }

  // ── Mini Projects APIs ───────────────────────────────────────────────────

  /// Fetch mini projects matched to user's role
  Future<List<dynamic>> fetchMiniProjects() async {
    final url = Uri.parse('$baseUrl/api/mini-projects');
    debugPrint('API GET -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded ?? [];
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch mini projects.');
      }
    } catch (e) {
      debugPrint('FetchMiniProjects API Error: $e');
      rethrow;
    }
  }

  /// Fetch a single mini project's details and submissions
  Future<Map<String, dynamic>> fetchMiniProjectDetail(String id) async {
    final url = Uri.parse('$baseUrl/api/mini-projects/$id');
    debugPrint('API GET -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch project detail.');
      }
    } catch (e) {
      debugPrint('FetchMiniProjectDetail API Error: $e');
      rethrow;
    }
  }

  /// Start a mini project
  Future<Map<String, dynamic>> startMiniProject(String id) async {
    final url = Uri.parse('$baseUrl/api/mini-projects/$id/start');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.post(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to start project.');
      }
    } catch (e) {
      debugPrint('StartMiniProject API Error: $e');
      rethrow;
    }
  }

  /// Submit a mini project file archive (ZIP/RAR).
  /// On web the file must be passed as [bytes] (dart:io paths are unavailable);
  /// on mobile/desktop either works.
  Future<Map<String, dynamic>> submitMiniProjectFile(
    String id,
    String? filePath,
    String fileName, {
    List<int>? bytes,
  }) async {
    final url = Uri.parse('$baseUrl/api/mini-projects/$id/submit');
    debugPrint('API POST MULTIPART -> $url');

    final request = http.MultipartRequest('POST', url);

    if (_cookieHeader != null) {
      request.headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }

    final http.MultipartFile file;
    if (bytes != null) {
      file = http.MultipartFile.fromBytes('file', bytes, filename: fileName);
    } else if (filePath != null) {
      file = await http.MultipartFile.fromPath('file', filePath, filename: fileName);
    } else {
      throw Exception('No file data provided.');
    }
    request.files.add(file);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to submit project file.');
      }
    } catch (e) {
      debugPrint('SubmitMiniProjectFile Error: $e');
      rethrow;
    }
  }

  /// Submit a mini project via GitHub repository URL
  Future<Map<String, dynamic>> submitMiniProjectGitHub(String id, String githubUrl) async {
    final url = Uri.parse('$baseUrl/api/mini-projects/$id/submit');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'github_url': githubUrl}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to submit project via GitHub.');
      }
    } catch (e) {
      debugPrint('SubmitMiniProjectGitHub API Error: $e');
      rethrow;
    }
  }

  // ── Simulations APIs ─────────────────────────────────────────────────────

  /// Start a new AI simulation session (recruiter or salary)
  Future<Map<String, dynamic>> startSimulation(
    String type, {
    String? companyName,
    String? role,
    String? scenario,
  }) async {
    final url = Uri.parse('$baseUrl/api/simulations/start');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'type': type,
          if (companyName != null) 'company_name': companyName,
          if (role != null) 'role': role,
          if (scenario != null) 'scenario': scenario,
        }),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to start simulation.');
      }
    } catch (e) {
      debugPrint('StartSimulation API Error: $e');
      rethrow;
    }
  }

  /// Send message to AI simulation session
  Future<Map<String, dynamic>> sendSimulationMessage(String simulationId, String text) async {
    final url = Uri.parse('$baseUrl/api/simulations/$simulationId/message');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'text': text}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to send simulation message.');
      }
    } catch (e) {
      debugPrint('SendSimulationMessage API Error: $e');
      rethrow;
    }
  }

  /// Fetch simulation details and messages
  Future<Map<String, dynamic>> getSimulationDetails(String simulationId) async {
    final url = Uri.parse('$baseUrl/api/simulations/$simulationId');
    debugPrint('API GET -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to get simulation details.');
      }
    } catch (e) {
      debugPrint('GetSimulationDetails API Error: $e');
      rethrow;
    }
  }

  // ── Dashboard / Analytics APIs ───────────────────────────────────────────

  /// Fetch dashboard summary (readiness score, streak, trend)
  Future<Map<String, dynamic>> getDashboardSummary() async {
    final url = Uri.parse('$baseUrl/api/dashboard/summary');
    debugPrint('API GET -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded;
      } else {
        throw Exception(decoded['message'] ?? 'Failed to get dashboard summary.');
      }
    } catch (e) {
      debugPrint('GetDashboardSummary API Error: $e');
      rethrow;
    }
  }

  /// Fetch skill gap analytics
  Future<List<dynamic>> getSkillGap() async {
    final url = Uri.parse('$baseUrl/api/readiness/skill-gap');
    debugPrint('API GET -> $url');

    final headers = _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded['result'] ?? decoded ?? [];
      } else {
        throw Exception(decoded['message'] ?? 'Failed to get skill gaps.');
      }
    } catch (e) {
      debugPrint('GetSkillGap API Error: $e');
      rethrow;
    }
  }

  /// Logout and clear cookies
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/api/auth/logout');
    debugPrint('API POST -> $url');

    final headers = _getHeaders();

    try {
      await http.post(url, headers: headers);
    } catch (e) {
      debugPrint('Logout API Error: $e');
    } finally {
      _cookieHeader = null;
      _accessToken = null;
      _refreshToken = null;
    }
  }

  /// Manually set session cookies (e.g. from mobile OAuth callback)
  void setSessionCookies({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _cookieHeader = 'access_token=$accessToken; refresh_token=$refreshToken';
    debugPrint('Manually Set Cookies: $_cookieHeader');
  }

  /// Parse and save set-cookie headers
  void _updateCookie(http.Response response) {
    final String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      final List<String> validCookies = [];
      
      final parts = rawCookie.split(',');
      for (var part in parts) {
        final trimmed = part.trim();
        if (trimmed.isEmpty) continue;
        
        final cookiePair = trimmed.split(';').first.trim();
        if (cookiePair.startsWith('access_token=')) {
          _accessToken = cookiePair.substring('access_token='.length);
          validCookies.add(cookiePair);
        } else if (cookiePair.startsWith('refresh_token=')) {
          _refreshToken = cookiePair.substring('refresh_token='.length);
          validCookies.add(cookiePair);
        }
      }

      if (validCookies.isNotEmpty) {
        _cookieHeader = validCookies.join('; ');
        debugPrint('Saved Cookies: $_cookieHeader');
      }
    }
  }
}
