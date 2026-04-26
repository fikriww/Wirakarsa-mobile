import 'package:flutter/material.dart';

/// Reusable project card widget for the DevHub mini projects list.
class ProjectCard extends StatelessWidget {
  final String title;
  final String gap;
  final List<String> tags;
  final double progress;
  final VoidCallback? onTapStartProject;
  final VoidCallback? onTapAskAI;

  const ProjectCard({
    super.key,
    required this.title,
    required this.gap,
    required this.tags,
    required this.progress,
    this.onTapStartProject,
    this.onTapAskAI,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E3A8A))),
              ),
              Text(gap,
                  style: const TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: tags
                .map((tag) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(tag,
                          style: TextStyle(color: Colors.blue[700], fontSize: 11)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: Colors.orange,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTapAskAI ?? () {},
                  icon: const Icon(Icons.chat_outlined, size: 18),
                  label: const Text("Ask AI Now"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onTapStartProject ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Start Project"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
