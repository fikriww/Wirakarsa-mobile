import 'dart:convert';

class MiniProject {
  final String id;
  final String title;
  final String description;
  final String gap;
  final List<String> tags;
  final double progress;

  MiniProject({
    required this.id,
    required this.title,
    required this.description,
    required this.gap,
    required this.tags,
    this.progress = 0.0,
  });

  MiniProject copyWith({
    String? id,
    String? title,
    String? description,
    String? gap,
    List<String>? tags,
    double? progress,
  }) {
    return MiniProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      gap: gap ?? this.gap,
      tags: tags ?? this.tags,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'gap': gap,
      'tags': tags,
      'progress': progress,
    };
  }

  factory MiniProject.fromMap(Map<String, dynamic> map, String id) {
    return MiniProject(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      gap: map['gap'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MiniProject.fromJson(String source) =>
      MiniProject.fromMap(json.decode(source), '');
}
