import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/models/mini_project_model.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class ProjectWorkspacePage extends ConsumerStatefulWidget {
  final String projectId;
  final MiniProject? projectFromExtra;

  const ProjectWorkspacePage({
    super.key,
    required this.projectId,
    this.projectFromExtra,
  });

  @override
  ConsumerState<ProjectWorkspacePage> createState() =>
      _ProjectWorkspacePageState();
}

class _ProjectWorkspacePageState
    extends ConsumerState<ProjectWorkspacePage> {
  // State
  MiniProject? _project;
  bool _isLoadingProject = false;
  bool _isSubmitting = false;

  // Submission mode: 'file' or 'github'
  String _mode = 'file';

  // File picker
  PlatformFile? _pickedFile;

  // GitHub URL
  final TextEditingController _githubController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.projectFromExtra != null) {
      _project = widget.projectFromExtra;
      // Also refresh in background to get latest submission data
      _fetchDetail();
    } else {
      _fetchDetail();
    }
  }

  @override
  void dispose() {
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _fetchDetail() async {
    if (_project == null) {
      setState(() => _isLoadingProject = true);
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
          _isLoadingProject = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProject = false);
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'rar', 'tar', 'gz', '7z'],
        allowMultiple: false,
        // On web there is no file path — we need the bytes to upload.
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedFile = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitProject() async {
    if (_project == null || _isSubmitting) return;

    // Validation
    if (_mode == 'file' && _pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please attach a ZIP/RAR file to submit.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_mode == 'github') {
      final url = _githubController.text.trim();
      if (url.isEmpty || !url.startsWith('https://github.com/')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid GitHub repository URL.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);
    try {
      final api = ref.read(apiServiceProvider);
      Map<String, dynamic> result;

      if (_mode == 'file' && _pickedFile != null) {
        result = await api.submitMiniProjectFile(
          _project!.id,
          _pickedFile!.path,
          _pickedFile!.name,
          bytes: _pickedFile!.bytes,
        );
      } else {
        result = await api.submitMiniProjectGitHub(
          _project!.id,
          _githubController.text.trim(),
        );
      }

      // Invalidate to refresh list
      ref.invalidate(miniProjectsProvider);

      // Reload detail to get updated submission data (and possibly AI review)
      await _fetchDetail();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project submitted successfully! AI review in progress.'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset pick state
        setState(() {
          _pickedFile = null;
          _githubController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submission failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProject && _project == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final project = _project;
    final title = project?.title ?? 'Project';
    final status = project?.submissionStatus ?? 'not_started';
    final hasReview = status == 'reviewed' && project != null;
    final hasSubmitted = status == 'submitted' || hasReview;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
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
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            const Text(
              'My Workspace',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        toolbarHeight: 72,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(
              left: 20, right: 20, top: 20, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── AI Review Results (if reviewed) ──────────────────────────
              if (hasReview) ...[
                _buildAiReviewSection(project!),
                const SizedBox(height: 30),
                const Divider(color: Colors.black12),
                const SizedBox(height: 20),
              ],

              // ── Submission section ────────────────────────────────────────
              const Text(
                'Submit Your Work',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                hasSubmitted
                    ? 'You can resubmit to improve your score.'
                    : 'Upload a ZIP/RAR archive or link your GitHub repo.',
                style:
                    const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Mode toggle
              Row(
                children: [
                  Expanded(
                    child: _ModeTab(
                      label: '📁  Upload File',
                      isActive: _mode == 'file',
                      onTap: () => setState(() => _mode = 'file'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ModeTab(
                      label: '  GitHub URL',
                      isActive: _mode == 'github',
                      onTap: () => setState(() => _mode = 'github'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (_mode == 'file') _buildFilePicker(),
              if (_mode == 'github') _buildGithubInput(),

              const SizedBox(height: 28),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          hasSubmitted
                              ? 'Resubmit Project'
                              : 'Submit Project',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
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

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _pickedFile != null
                    ? Colors.blue.shade300
                    : Colors.black12,
                width: _pickedFile != null ? 1.5 : 1,
              ),
            ),
            child: _pickedFile == null
                ? Column(
                    children: [
                      Icon(Icons.upload_file_outlined,
                          size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap to select ZIP / RAR file',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Supported: .zip, .rar, .tar, .gz, .7z',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 11),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(Icons.insert_drive_file_outlined,
                          color: Colors.blue, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _pickedFile!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatBytes(_pickedFile!.size),
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _pickedFile = null),
                        child: const Icon(Icons.close,
                            color: Colors.grey, size: 20),
                      ),
                    ],
                  ),
          ),
        ),
        if (_pickedFile == null) ...[
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file, color: Colors.blue, size: 18),
            label: const Text(
              'Attach File',
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGithubInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GitHub Repository URL',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _githubController,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'https://github.com/yourusername/repo',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.link, color: Colors.grey.shade500, size: 20),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 44, minHeight: 44),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Make sure your repo is public so our AI can analyze it.',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildAiReviewSection(MiniProject project) {
    final score = project.overallScore;
    final scoreText = score != null ? '${score.round()}/100' : '—';
    Color scoreColor = Colors.green;
    if (score != null && score < 60) scoreColor = Colors.red;
    else if (score != null && score < 80) scoreColor = Colors.orange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'AI Review Results',
              style:
                  TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Score and status row
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                scoreText,
                style: TextStyle(
                  color: scoreColor,
                  fontSize: score != null ? 24 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Graded',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (project.reviewedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Reviewed ${_formatDate(project.reviewedAt!)}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: score != null && score >= 80
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      score != null && score >= 80
                          ? 'Passed'
                          : 'Needs Revision',
                      style: TextStyle(
                        color: score != null && score >= 80
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // AI Summary
        if (project.submissionId != null) ...[
          const SizedBox(height: 20),
          const Text(
            'AI Feedback Summary',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Note: aiSummary would come from full submission data
          // (exposed via fetchMiniProjectDetail extended response)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.withOpacity(0.15)),
            ),
            child: const Text(
              'Detailed AI feedback is available. Submit or resubmit to see full analysis.',
              style: TextStyle(
                  fontSize: 13, height: 1.5, color: Colors.black87),
            ),
          ),
        ],
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

/// Small toggle tab widget for file/github mode
class _ModeTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0D6EFD) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
