import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/health%20metric%20management/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/health%20metric%20management/domain/usecase/add_health_metric.dart';
import '../../../core/errors/failure.dart';
import '../../domain/usecase/delete_health_metric.dart';
import 'health_metric_state.dart';

class HealthMetricCubit extends Cubit<HealthMetricState> {
  final AddHealthMetric addHealthMetricUseCase;
  final DeleteHealthMetric deleteHealthMetricUseCase;
  final GetAllHealthMetricsByPatient getAllHealthMetricByPatientUseCase;
  final EditHealthMetric editHealthMetricUseCase;

  List<HealthMetric> _healthMetricsCache = [];

  HealthMetricCubit({
    required this.addHealthMetricUseCase,
    required this.deleteHealthMetricUseCase,
    required this.getAllHealthMetricByPatientUseCase,
    required this.editHealthMetricUseCase,
  }) : super(HealthMetricInitial());

  // Get all health metrics and cache them locally
  Future<void> getAllHealthMetric(String patientId) async {
    emit(HealthMetricLoading());

    final Either<Failure, List<HealthMetric>> result =
        await getAllHealthMetricByPatientUseCase.call(patientId);

    result.fold(
      (failure) => emit(HealthMetricError(_mapFailureToMessage(failure))
          as HealthMetricState),
      (healthMetrics) {
        _healthMetricsCache = healthMetrics;
        emit(HealthMetricLoaded(
            healthMetrics: _healthMetricsCache, healthmetric: []));
      },
    );
  }

  // Add a health metric and add it to the cache
  Future<void> addHealthMetric(HealthMetric healthMetric) async {
    emit(HealthMetricLoading());

    final Either<Failure, void> result =
        await addHealthMetricUseCase.call(healthMetric);

    result.fold(
      (failure) => emit(HealthMetricError(_mapFailureToMessage(failure))
          as HealthMetricState),
      (_) {
        _healthMetricsCache.add(healthMetric);
        emit(HealthMetricLoaded(
            healthMetrics: _healthMetricsCache, healthmetric: []));
      },
    );
  }

  // Edit a health metric and update it in the cache
  // ignore: non_constant_identifier_names
  Future<void> editHealthMetric(HealthMetric healthMetric) async {
    emit(HealthMetricLoading());

    // Ensure this line returns an Either<Failure, void>
    final Either<Failure, void> result =
        await editHealthMetricUseCase.call(healthMetric);

    result.fold(
      (failure) => emit(HealthMetricError(_mapFailureToMessage(failure))
          as HealthMetricState),
      (_) {
        final index =
            _healthMetricsCache.indexWhere((e) => e.id == healthMetric.id);
        if (index != -1) {
          _healthMetricsCache[index] = healthMetric; // update cache
          emit(HealthMetricLoaded(
              healthMetrics: List.from(_healthMetricsCache), healthmetric: []));
        } else {
          // ignore: prefer_const_constructors
          emit(HealthMetricError("HealthMetric not found in cache")
              as HealthMetricState);
        }
      },
    );
  }

  // Delete a health metric from the cache
  Future<void> deleteHealthMetric(String id) async {
    emit(HealthMetricLoading());

    final Either<Failure, void> result =
        await deleteHealthMetricUseCase.call(id);

    result.fold(
      (failure) => emit(HealthMetricError(_mapFailureToMessage(failure))
          as HealthMetricState),
      (_) {
        _healthMetricsCache
            .removeWhere((healthMetric) => healthMetric.id == id);
        emit(HealthMetricLoaded(
            healthMetrics: _healthMetricsCache, healthmetric: []));
      },
    );
  }

  //Helper  methods to map Failure to a readable message
  String _mapFailureToMessage(Failure failure) {
    //Customize error handling based on the type of Failure
    return failure.toString(); //Modify this according to your failure structure
  }
}

class EditHealthMetric {
  call(HealthMetric healthMetric) {}
}

class GetAllHealthMetricsByPatient {
  call(String patientId) {}
}

class GetAllHealthMetricsByPatientId {
  call(String id) {}
}

//Define the states for the HealthMetricCubit
abstract class HealthMetricState {}

class HealthMetricInitial extends HealthMetricState {}

class HealthMetricLoading extends HealthMetricState {}

class HealthMetricLoaded extends HealthMetricState {
  final List<HealthMetric> healthmetric;

  HealthMetricLoaded(
      {required this.healthmetric, required List<HealthMetric> healthMetrics});
}

abstract class HealthmetricError extends HealthMetricState {
  late final String message;

  // ignore: non_constant_identifier_names
  HealthMetricError(message);
}
