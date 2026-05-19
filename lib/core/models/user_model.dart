import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool hasCompletedAssessment;
  final String role;
  final Map<String, double> skills;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.lastActive,
    this.hasCompletedAssessment = false,
    this.role = 'user',
    this.skills = const {},
    this.preferences = const {},
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? hasCompletedAssessment,
    String? role,
    Map<String, double>? skills,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      hasCompletedAssessment:
          hasCompletedAssessment ?? this.hasCompletedAssessment,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'hasCompletedAssessment': hasCompletedAssessment,
      'role': role,
      'skills': skills,
      'preferences': preferences,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: (map['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
      hasCompletedAssessment: map['hasCompletedAssessment'] ?? false,
      role: map['role'] ?? 'user',
      skills: Map<String, double>.from(map['skills'] ?? {}),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source), '');
}
