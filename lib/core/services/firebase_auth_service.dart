import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_config.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: FirebaseConfig.databaseId,
  );

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  /// Sign In with Email and Password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Update last active and self-heal missing Firestore document
      if (credential.user != null) {
        await _ensureUserDocumentExists(credential.user!);
      }
      
      return credential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred during sign in: $e');
    }
  }

  /// Sign Up (Create Account) with Email and Password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Set display name in Firebase Auth
        if (displayName != null && displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
        }

        // Initialize user document in Cloud Firestore
        try {
          debugPrint('Attempting to create Firestore document for UID: ${user.uid}');
          final userDoc = {
            'uid': user.uid,
            'email': user.email ?? email,
            'displayName': displayName ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'lastActive': FieldValue.serverTimestamp(),
            'hasCompletedAssessment': false,
            'role': 'user',
            'skills': {},
            'preferences': {},
          };
          
          await _firestore.collection('users').doc(user.uid).set(userDoc).timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Firestore write timed out (15s limit reached)');
            },
          );
          debugPrint('Firestore document created successfully for UID: ${user.uid}');
        } catch (e) {
          debugPrint('CRITICAL: Error creating user profile in Firestore: $e');
          // Clean up the auth user so they aren't stuck in a half-registered state
          try {
            await user.delete();
            debugPrint('Successfully cleaned up Auth user after Firestore failure');
          } catch (cleanupError) {
            debugPrint('Failed to delete Auth user during cleanup: $cleanupError');
          }
          throw Exception('Failed to initialize user database profile. Error: $e');
        }
      }

      return credential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred during registration: $e');
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('An unexpected error occurred during sign out: $e');
    }
  }

  /// Send Password Reset Email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred sending password reset: $e');
    }
  }

  /// Get User Firestore Document
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  /// Update User Profile Data (e.g. readiness assessments, theme preferences, etc.)
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection('users').doc(uid).set(
      {
        ...data,
        'lastActive': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Ensure user document exists in Firestore and update last active (Self-healing mechanism)
  Future<void> _ensureUserDocumentExists(User user) async {
    try {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnap = await docRef.get().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Checking database timed out');
        },
      );
      
      if (!docSnap.exists) {
        debugPrint('User document does not exist for UID: ${user.uid}. Initializing missing document.');
        final userDoc = {
          'uid': user.uid,
          'email': user.email ?? '',
          'displayName': user.displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
          'hasCompletedAssessment': false,
          'role': 'user',
          'skills': {},
          'preferences': {},
        };
        await docRef.set(userDoc).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Initializing database profile timed out');
          },
        );
      } else {
        await docRef.update({
          'lastActive': FieldValue.serverTimestamp(),
        }).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Updating last active timed out');
          },
        );
      }
    } catch (e) {
      debugPrint('CRITICAL: Error ensuring user document exists in Firestore: $e');
      throw Exception('Database synchronization failed. Please check connection and try again. (Details: $e)');
    }
  }

  /// Save Initial Test Result
  Future<void> saveTestResult({
    required String uid,
    required Map<String, dynamic> resultData,
  }) async {
    try {
      final docRef = _firestore.collection('test_results').doc();
      await docRef.set({
        ...resultData,
        'userId': uid,
        'submittedAt': FieldValue.serverTimestamp(),
      }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Test result save timed out');
        },
      );
      debugPrint('Test result saved successfully with ID: ${docRef.id}');
    } catch (e) {
      debugPrint('Error saving test result: $e');
      rethrow;
    }
  }
}
