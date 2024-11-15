import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/health%20metric%20management/domain/repositories/health_metric_repos.dart';

import '../../../core/errors/failure.dart';

class DeleteHealthMetric {
  final HealthMetricRepository repository;

  DeleteHealthMetric({required this.repository});

  Future<Either<Failure, void>> call(String id) async => await repository.deleteHealthMetric(id);
}
