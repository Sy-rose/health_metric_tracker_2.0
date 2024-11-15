import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/health%20metric%20management/domain/repositories/health_metric_repos.dart';

class GetAHealthMetricsByPatientId {
  final HealthMetricRepository repository;

  GetAHealthMetricsByPatientId({required this.repository});

  Future<Either<Failure, List>> call(String patientId) async {
    return await repository.getHealthMetricsByPatientId(patientId);
  }
}
