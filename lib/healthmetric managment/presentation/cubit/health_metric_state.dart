import 'package:equatable/equatable.dart';
import '../../domain/entities/health_metric.dart';

abstract class HealthMetricState extends Equatable {
  const HealthMetricState();

  @override
  List<Object?> get props => [];
}

// Initial State
class HealthMetricInitial extends HealthMetricState {}

// Loading State
class HealthMetricLoading extends HealthMetricState {}

// Success State (with List<HealthMetric>)
class HealthMetricLoaded extends HealthMetricState {
  final List<HealthMetric> healthMetrics;

  const HealthMetricLoaded({required this.healthMetrics});

  @override
  List<Object?> get props => [healthMetrics];

  get metrics => null;
}

class HealthMetricAdded extends HealthMetricState {}

class HealthMetricDelete extends HealthMetricState {}

class HealthMetricUpdated extends HealthMetricState {
  final HealthMetric newHealthMetric;

  const HealthMetricUpdated(this.newHealthMetric);

  @override
  List<Object?> get props => [newHealthMetric];
}

// ignore: non_constant_identifier_names
class HealthMetricError extends HealthMetricState {
  final String message;

  const HealthMetricError(this.message);

  @override
  List<Object?> get props => [message];
}
