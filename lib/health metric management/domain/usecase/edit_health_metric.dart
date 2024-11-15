import 'package:health_metrics_tracker/health%20metric%20management/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/health%20metric%20management/domain/repositories/health_metric_repos.dart';

class EditHealthMetric {
  final HealthMetricRepository repository;

  EditHealthMetric({required this.repository});

  Future<void> call(HealthMetric metric) async {
    await repository.editHealthMetric(metric);
  }
}
