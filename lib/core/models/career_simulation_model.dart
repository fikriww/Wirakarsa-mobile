import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class CareerSimulationSession {
  final String id;
  final String userId;
  final String type;
  final String companyName;
  final String role;
  final String level;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CareerSimulationSession({
    required this.id,
    required this.userId,
    required this.type,
    required this.companyName,
    required this.role,
    required this.level,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  CareerSimulationSession copyWith({
    String? id,
    String? userId,
    String? type,
    String? companyName,
    String? role,
    String? level,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CareerSimulationSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      companyName: companyName ?? this.companyName,
      role: role ?? this.role,
      level: level ?? this.level,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'companyName': companyName,
      'role': role,
      'level': level,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory CareerSimulationSession.fromMap(Map<String, dynamic> map, String id) {
    return CareerSimulationSession(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      companyName: map['companyName'] ?? '',
      role: map['role'] ?? '',
      level: map['level'] ?? '',
      status: map['status'] ?? 'active',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CareerSimulationSession.fromJson(String source) =>
      CareerSimulationSession.fromMap(json.decode(source), '');
}
