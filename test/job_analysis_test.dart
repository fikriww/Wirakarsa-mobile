import 'package:flutter_test/flutter_test.dart';
import 'package:wirapath/features/simulation/data/services/job_analysis_api_service.dart';

void main() {
  test('JobAnalysisApiService retrieves skills prediction', () async {
    final service = JobAnalysisApiService();
    
    // Query API
    final response = await service.predictRequiredSkills('Frontend Developer', topK: 5);
    
    // Assert response content
    expect(response.jobTitle, equals('Frontend Developer'));
    expect(response.status, equals('success'));
    expect(response.skills, isNotEmpty);
    expect(response.skills.length, equals(5));
    
    // Check first skill structure
    final firstSkill = response.skills.first;
    expect(firstSkill.skill, isNotEmpty);
    expect(firstSkill.confidence, greaterThan(0.0));
    expect(firstSkill.confidencePct, greaterThan(0.0));
  });
}
