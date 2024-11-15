import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:health_metrics_tracker/core/errors/failure.dart';
import '../../domain/entities/patient.dart';
import '../../domain/usecase/add_patient_.dart';
import '../../domain/usecase/delete_patient.dart';
import '../../domain/usecase/edit_patient.dart';
// ignore: unused_import
import 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final AddPatient addPatientUseCase;
  final DeletePatient deletePatientUseCase;
  final GetAllHealthMetricsByPatientId getAllHealthMetricsByPatientIdUseCase;
  final EditPatient editPatientUseCase;

  List<Patient> _patientCache = []; // Local cache for patients

  PatientCubit({
    required this.addPatientUseCase,
    required this.deletePatientUseCase,
    required this.getAllHealthMetricsByPatientIdUseCase,
    required this.editPatientUseCase,
  }) : super(PatientInitial());

  // Get all health metrics by patient ID and cache the result locally
  Future<void> getAllHealthMetricsByPatient(String id) async {
    emit(PatientLoading());

    final Either<Failure, List<Patient>> result =
        await getAllHealthMetricsByPatientIdUseCase.call(id);

    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (patients) {
        _patientCache = patients;
        emit(PatientLoaded(patients: _patientCache));
      },
    );
  }

  // Add a patient and update the cache
  Future<void> addPatient(Patient patient) async {
    emit(PatientLoading());

    final Either<Failure, void> result = await addPatientUseCase.call(patient);

    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (_) {
        _patientCache.add(patient);
        emit(PatientLoaded(patients: _patientCache));
      },
    );
  }

  // Edit a patient and update the cache
  Future<void> editPatient(Patient patient) async {
    emit(PatientLoading());

    final Either<Failure, void> result = await editPatientUseCase.call(patient);

    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (_) {
        final index = _patientCache.indexWhere((e) => e.id == patient.id);
        if (index != -1) {
          _patientCache[index] = patient;
          emit(PatientLoaded(patients: List.from(_patientCache)));
        } else {
          emit(PatientError("Patient not found in cache"));
        }
      },
    );
  }

  // Delete a patient and update the cache
  Future<void> deletePatient(String id) async {
    emit(PatientLoading());

    final Either<Failure, void> result = await deletePatientUseCase.call(id);

    result.fold(
      (failure) => emit(PatientError(_mapFailureToMessage(failure))),
      (_) {
        _patientCache.removeWhere((patient) => patient.id == id);
        emit(PatientLoaded(patients: _patientCache));
      },
    );
  }

  // Helper method to map Failure to a readable message
  String _mapFailureToMessage(Failure failure) {
    // Customize error handling based on the type of Failure
    return failure.toString(); // Modify this according to your failure structure
  }
}

class GetAllHealthMetricsByPatientId {
  call(String id) {}
}

// Define the states for the PatientCubit
abstract class PatientState {}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final List<Patient> patients;

  PatientLoaded({required this.patients});
}

class PatientError extends PatientState {
  final String message;

  PatientError(this.message);
}
