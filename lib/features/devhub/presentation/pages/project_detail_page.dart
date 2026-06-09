import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/mini_project_model.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;
  final MiniProject? projectFromExtra;

  const ProjectDetailPage({
    super.key,
    required this.projectId,
    this.projectFromExtra,
  });

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
  MiniProject? _project;
  bool _isLoading = false;
  bool _isStarting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.projectFromExtra != null) {
      _project = widget.projectFromExtra;
      // Fetch live detail for full brief & submission status
      _fetchDetail();
    } else {
      _fetchDetail();
    }
  }

  Future<void> _fetchDetail() async {
    if (_project == null) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
    try {
      final api = ref.read(apiServiceProvider);
      final data = await api.fetchMiniProjectDetail(widget.projectId);
      if (mounted) {
        setState(() {
          _project = MiniProject.fromMap(
            Map<String, dynamic>.from(data),
            data['id']?.toString() ?? widget.projectId,
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _startProject() async {
    if (_project == null || _isStarting) return;
    setState(() => _isStarting = true);
    try {
      final api = ref.read(apiServiceProvider);
      await api.startMiniProject(_project!.id);
      ref.invalidate(miniProjectsProvider);
      await _fetchDetail();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start project: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _project == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _project == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Failed to load project', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchDetail,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final project = _project!;
    final status = project.submissionStatus;
    final hasSubmission = status == 'submitted' || status == 'reviewed';
    final hasReview = status == 'reviewed';

    // Badge color for skill gap level (score indicates readiness, not gap)
    Color badgeColor = Colors.yellow.shade700;
    if (project.overallScore != null) {
      if (project.overallScore! >= 80) {
        badgeColor = Colors.green.shade700;
      } else if (project.overallScore! < 50) {
        badgeColor = Colors.red.shade700;
      }
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/devhub');
            }
          },
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${project.level} • ${project.duration}${project.tag.isNotEmpty ? ' • ${project.tag}' : ''}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          if (project.overallScore != null)
            Container(
              margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${project.overallScore!.round()}%',
                style: TextStyle(
                  color: badgeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
        toolbarHeight: 80,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status banner
              if (hasSubmission) _buildStatusBanner(status),
              if (hasSubmission) const SizedBox(height: 20),

              // Brief section
              const Text(
                'Brief',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF1FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Text(
                  project.brief.isNotEmpty
                      ? project.brief
                      : project.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Skills section
              if (project.relatedSkills.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Skills You\'ll Build',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.relatedSkills
                      .map((s) => Chip(
                            label: Text(s, style: const TextStyle(fontSize: 12)),
                            backgroundColor: const Color(0xFFEFF6FF),
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),
              ],

              // Evaluation criteria
              if (project.evaluationCriteria.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Evaluation Criteria',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...project.evaluationCriteria.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(Icons.check_circle_outline,
                                size: 16, color: Colors.blue),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(c,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black87)),
                          ),
                        ],
                      ),
                    )),
              ],

              const SizedBox(height: 30),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isStarting
                      ? null
                      : () {
                          if (status == 'not_started') {
                            _startProject().then((_) {
                              if (mounted) {
                                context.push(
                                  '/devhub/project/${project.id}/workspace',
                                  extra: _project ?? project,
                                );
                              }
                            });
                          } else {
                            context.push(
                              '/devhub/project/${project.id}/workspace',
                              extra: project,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: _isStarting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          hasSubmission ? 'View Submission & Results' : 'Start Project',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildStatusBanner(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    switch (status) {
      case 'reviewed':
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF065F46);
        icon = Icons.check_circle_outline;
        label = 'Reviewed — see your AI feedback below';
        break;
      case 'submitted':
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFF92400E);
        icon = Icons.hourglass_empty;
        label = 'Submitted — waiting for AI review';
        break;
      default:
        bgColor = const Color(0xFFEFF6FF);
        textColor = const Color(0xFF1E40AF);
        icon = Icons.play_circle_outline;
        label = 'In Progress';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
