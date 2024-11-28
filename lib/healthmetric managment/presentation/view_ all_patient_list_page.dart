// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/core/widgets/empty_state_list.dart';
import 'package:health_metrics_tracker/core/widgets/error_state_list.dart';
import 'package:health_metrics_tracker/core/widgets/loading_state_circular_progress.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/add_edit_patient_page.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';

class ViewAllPatientsPage extends StatefulWidget {
  const ViewAllPatientsPage({super.key});

  @override
  State<ViewAllPatientsPage> createState() => _ViewAllPatientsPageState();
}

class _ViewAllPatientsPageState extends State<ViewAllPatientsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch all patients when this page loads
    context.read<PatientCubit>().getAllPatient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Designer.png',
          ),
        ),
        title: const Text("Patients"),
      ),
      body: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, state) {
          // Handle different states based on the current PatientCubit state
          if (state is PatientLoading) {
            return const LoadingStateCircularProgress();
          } else if (state is PatientLoaded) {
            // Display a message if no patients are found
            if (state.patients.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/Designer.png',
                title: 'No patients found',
                description: 'Tap the "+" button to add new patients.',
              );
            }
            // Display the list of patients
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.patients.length,
              itemBuilder: (context, index) {
                final currentPatient = state.patients[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      currentPatient.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Age: ${currentPatient.age} | Gender: ${currentPatient.gender}",
                    ),
                    onTap: () async {
                      // Navigate to the Add/Edit Patient page
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => serviceLocator<PatientCubit>(),
                              ),
                            ],
                            child: AddEditPatientPage(patient: currentPatient),
                          ),
                        ),
                      );

                      // Refresh the patient list after returning from Add/Edit page
                      context.read<PatientCubit>().getAllPatient();

                      // Show SnackBar if result is a String
                      if (result is String) {
                        final snackBar = SnackBar(content: Text(result));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is PatientError) {
            return ErrorStateList(
              imageAssetName: 'assets/pngegg.png',
              errorMessage: state.message,
              onRetry: () {
                // Retry loading the patients list
                context.read<PatientCubit>().getAllPatient();
              },
              message: 'Error fetching patients. Tap to retry.',
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/Designer.png',
              title: 'Oops... There are no patients found.',
              description: "Tap '+' to add a new patient.",
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the Add/Edit Patient page
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => serviceLocator<PatientCubit>(),
                  ),
                ],
                child: const AddEditPatientPage(patient: null),
              ),
            ),
          );

          // Refresh the patient list after adding a new patient
          context.read<PatientCubit>().getAllPatient();

          // Show SnackBar if result is a String
          if (result is String) {
            final snackBar = SnackBar(content: Text(result));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
