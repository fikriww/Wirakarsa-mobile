import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Use localhost for Web/iOS, and 10.0.2.2 for Android Emulator.
  static final String baseUrl = kIsWeb ? 'http://localhost:5001' : (defaultTargetPlatform == TargetPlatform.android ? 'http://10.0.2.2:5001' : 'http://localhost:5001');

  // In-memory storage for JWT cookies and tokens
  static String? _cookieHeader;
  static String? _accessToken;
  static String? _refreshToken;

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

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_cookieHeader != null) {
      headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

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

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_cookieHeader != null) {
      headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

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

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_cookieHeader != null) {
      headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

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

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_cookieHeader != null) {
      headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

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

  /// Logout and clear cookies
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/api/auth/logout');
    debugPrint('API POST -> $url');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_cookieHeader != null) {
      headers['cookie'] = _cookieHeader!;
    }
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

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
      
      // Sometimes multiple cookies are combined using commas (e.g. "access_token=foo; ..., refresh_token=bar; ...")
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
