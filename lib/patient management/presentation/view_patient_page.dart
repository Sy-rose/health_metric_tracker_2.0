import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';

class ViewPatientPage extends StatefulWidget {
  final Patient patient;

  const ViewPatientPage({
    super.key,
    required this.patient,
  });

  @override
  State<ViewPatientPage> createState() => _ViewPatientPageState();
}

class _ViewPatientPageState extends State<ViewPatientPage> {
  late Patient _currentPatient;

  @override
  void initState() {
    super.initState();
    _currentPatient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientCubit, PatientState>(
      listener: (context, state) {
        if (state is PatientDelete) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Patient Deleted");
        } else if (state is PatientError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Back To Patient List",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.person, size: 150),
              Text(
                _currentPatient.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Text('Age: ${_currentPatient.age}, Gender: ${_currentPatient.gender}'),
              Text(_currentPatient.contactInfo),
              const SizedBox(height: 30),
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => serviceLocator<PatientCubit>(),
                              child: AddEditPatientPage(patient: _currentPatient),
                            ),
                          ),
                        );

                        if (result.runtimeType == Patient) {
                          setState(() {
                            _currentPatient = result;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text("Edit Patient"),
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Add some space between the buttons
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        const snackBar = SnackBar(
                          content: Text("Deleting Patient..."),
                          duration: Duration(seconds: 9),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        context.read<PatientCubit>().deletePatient(widget.patient.id);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text("Delete Patient"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // ignore: non_constant_identifier_names
  AddEditPatientPage({required Patient patient}) {}
}

