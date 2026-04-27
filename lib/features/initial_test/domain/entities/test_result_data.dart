import 'package:flutter/material.dart';

/// Represents one metric item in the 2x2 grid
class TestMetric {
  final String label;
  final String? sublabel;

  /// Either a checkmark (true), cross (false), or null (use valueText instead)
  final bool? checkStatus;

  /// Numeric or text value to display instead of check/cross
  final String? valueText;

  /// Color for the valueText
  final Color? valueColor;

  const TestMetric({
    required this.label,
    this.sublabel,
    this.checkStatus,
    this.valueText,
    this.valueColor,
  });
}

/// Represents an "Issue to Fix" card
class TestIssue {
  final String title;
  final String description;
  final Color cardColor;
  final Color borderColor;
  final Color titleColor;

  const TestIssue({
    required this.title,
    required this.description,
    required this.cardColor,
    required this.borderColor,
    required this.titleColor,
  });
}

/// All the data needed to render a Test Graded page
class TestResultData {
  final String testTitle;
  final String testSubtitle;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;

  /// Score value (e.g. "4/5" or "76")
  final String scoreValue;

  /// Max score for circular display (e.g. 5 or 100)
  final double maxScore;

  /// Actual numeric score for progress ring
  final double numericScore;

  final String submittedDate;
  final String statusText;
  final Color statusColor;
  final Color statusTextColor;

  final String aiSummary;

  /// Optional 2x2 metrics grid
  final List<TestMetric>? metrics;

  /// List of issues to fix
  final List<TestIssue> issues;

  /// Optional quoted text shown before issues
  final String? quotedText;

  const TestResultData({
    required this.testTitle,
    required this.testSubtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.scoreValue,
    required this.maxScore,
    required this.numericScore,
    required this.submittedDate,
    required this.statusText,
    required this.statusColor,
    required this.statusTextColor,
    required this.aiSummary,
    this.metrics,
    required this.issues,
    this.quotedText,
  });
}
