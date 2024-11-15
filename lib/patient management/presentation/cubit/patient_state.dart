// part of 'patient_cubit.dart'; 
// Define different states for PatientCubit
import 'package:equatable/equatable.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object?> get props => [];
}

// Initial State
class PatientInitial extends PatientState {}

// Loading State
class PatientLoading extends PatientState {}

// Success State (with List<Patient>)
class PatientLoaded extends PatientState {
  final List<Patient> patients;

  const PatientLoaded({required this.patients});

  @override
  List<Object?> get props => [patients];
}

// Error State (with error message)
class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object?> get props => [message];
}
