import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/add_patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/delete_patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/edit_patient.dart';
import 'package:health_metrics_tracker/patient%20management/domain/usecases/get_all_patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';


const String noInternetErrorMessage =
    "Sync Failed: Changes saved on your device will sync once you're back online";

class PatientCubit extends Cubit<PatientState> {
  final AddPatient addPatientUseCase;
  final DeletePatient deletePatientUseCase;
  final GetAllPatients getAllPatientsUseCase;
  final EditPatient editPatientUseCase;

  PatientCubit({
    required this.addPatientUseCase,
    required this.deletePatientUseCase,
    required this.getAllPatientsUseCase,
    required this.editPatientUseCase,
  }) : super(PatientInitial());

  // Get all health metrics by patient ID and cache the result locally
  Future<void> getAllHealthMetricsByPatient(String id) async {
    emit(PatientLoading());

    try {
      final Either<Failure, List<Patient>> result = await getAllPatientsUseCase
          .call()
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request Timed Out."));

      result.fold(
        (failure) => emit(PatientError(failure.getMessage())),
        (patients) {
          emit(PatientLoaded(patients: patients));
        },
      );
    } on TimeoutException catch (_) {
      emit(const PatientError("Check your Internet Connection"));
    }
  }

  // Add a patient and update the cache
  Future<void> addPatient(Patient patient) async {
    emit(PatientLoading());

    try {
      final Either<Failure, void> result = await addPatientUseCase
          .call(patient)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request Timed Out."));

      result.fold(
        (failure) => emit(PatientError(failure.getMessage())),
        (_) {
          emit(PatientAdded());
        },
      );
    } catch (_) {
      emit(const PatientError(noInternetErrorMessage));
    }
  }

  // Edit a patient and update the cache
  Future<void> editPatient(Patient patient) async {
    emit(PatientLoading());

    try {
      final Either<Failure, void> result = await editPatientUseCase
          .call(patient)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request Timed Out."));

      result.fold(
        (failure) => emit(PatientError(failure.getMessage())),
        (_) {
          emit(PatientUpdated(patient ));
        },
      );
    } catch (_) {
      emit(const PatientError(noInternetErrorMessage));
    }
  }

  // Delete a patient and update the cache
  Future<void> deletePatient(String id) async {
    emit(PatientLoading());

    try {
      final Either<Failure, void> result = await deletePatientUseCase
          .call(id)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request Timed Out."));

      result.fold(
        (failure) => emit(PatientError(failure.getMessage())),
        (_) {
          emit(PatientDelete());
        },
      );
    } catch (_) {
      emit(const PatientError(noInternetErrorMessage));
    }
  }

  void fetchAllPatient() {}

  void getAllPatient() {}

}

