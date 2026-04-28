import 'package:flutter/material.dart';

/// Represents a single question option
class QuestionOption {
  final String text;
  final bool isCorrect;

  const QuestionOption({
    required this.text,
    this.isCorrect = false,
  });
}

/// Represents a single question
class TestQuestion {
  final String questionText;
  final List<QuestionOption> options;

  const TestQuestion({
    required this.questionText,
    required this.options,
  });
}

/// Represents an upload field for file-based tests
class UploadField {
  final String label;
  final String supportedFormats;

  const UploadField({
    required this.label,
    this.supportedFormats = 'Supports only .xlsx (Max 10 MB)',
  });
}

/// Represents a text input field for essay-based tests
class EssayField {
  final String label;
  final String placeholder;

  const EssayField({
    required this.label,
    this.placeholder = '',
  });
}

/// All data needed to render an initial test page
class InitialTestData {
  final String testTitle;
  final String testSubtitle;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;

  /// Multiple choice questions (if any)
  final List<TestQuestion>? questions;

  /// Practical task description (for file upload tests)
  final String? practicalTaskDescription;

  /// Upload fields
  final List<UploadField>? uploadFields;

  /// Essay fields
  final List<EssayField>? essayFields;

  const InitialTestData({
    required this.testTitle,
    required this.testSubtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    this.questions,
    this.practicalTaskDescription,
    this.uploadFields,
    this.essayFields,
  });
}
