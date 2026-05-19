import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class CodeReview {
  final String id;
  final String userId;
  final String projectId;
  final String submittedCode;
  final String status;
  final DateTime createdAt;
  final String? feedbackSummary;
  final List<ReviewImprovement> improvements;

  CodeReview({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.submittedCode,
    required this.status,
    required this.createdAt,
    this.feedbackSummary,
    this.improvements = const [],
  });

  CodeReview copyWith({
    String? id,
    String? userId,
    String? projectId,
    String? submittedCode,
    String? status,
    DateTime? createdAt,
    String? feedbackSummary,
    List<ReviewImprovement>? improvements,
  }) {
    return CodeReview(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      submittedCode: submittedCode ?? this.submittedCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      feedbackSummary: feedbackSummary ?? this.feedbackSummary,
      improvements: improvements ?? this.improvements,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'projectId': projectId,
      'submittedCode': submittedCode,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'feedbackSummary': feedbackSummary,
      'improvements': improvements.map((x) => x.toMap()).toList(),
    };
  }

  factory CodeReview.fromMap(Map<String, dynamic> map, String id) {
    return CodeReview(
      id: id,
      userId: map['userId'] ?? '',
      projectId: map['projectId'] ?? '',
      submittedCode: map['submittedCode'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      feedbackSummary: map['feedbackSummary'],
      improvements: List<ReviewImprovement>.from(
          map['improvements']?.map((x) => ReviewImprovement.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeReview.fromJson(String source) =>
      CodeReview.fromMap(json.decode(source), '');
}

class ReviewImprovement {
  final String category;
  final String text;
  final bool isCompleted;

  ReviewImprovement({
    required this.category,
    required this.text,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'text': text,
      'isCompleted': isCompleted,
    };
  }

  factory ReviewImprovement.fromMap(Map<String, dynamic> map) {
    return ReviewImprovement(
      category: map['category'] ?? '',
      text: map['text'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
