import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';

class AddEditPatientPage extends StatefulWidget {
  final Patient? patient;

  const AddEditPatientPage({super.key, this.patient});

  @override
  State<AddEditPatientPage> createState() => _AddEditPatientPageState();
}

class _AddEditPatientPageState extends State<AddEditPatientPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle =
        widget.patient == null ? "Add New Patient" : "Edit Patient";
    String buttonLabel =
        widget.patient == null ? "Add Patient" : "Update Patient";
    final initialValues = {
      "name": widget.patient?.name ?? '',
      "age": widget.patient?.age.toString() ?? '',
      "gender": widget.patient?.gender ?? '',
      "contactInfo": widget.patient?.contactInfo ?? '',
    };

    return BlocListener<PatientCubit, PatientState>(
      listener: (context, state) {
        if (state is PatientAdded) {
          Navigator.pop(context, "Patient Added Successfully.");
        } else if (state is PatientError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is PatientUpdated) {
          Navigator.pop(context, state.newPatient);
        } else if (state is PatientDelete) {
          Navigator.pop(context, "Patient Deleted Successfully.");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: _formKey,
                initialValue: initialValues,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    // For Name
                    FormBuilderTextField(
                      name: "name",
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      initialValue: initialValues["name"] as String,
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 8),

                    // For Age
                    FormBuilderTextField(
                      name: "age",
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Age',
                      ),
                      initialValue: initialValues["age"] as String,
                      validator: FormBuilderValidators.required(),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),

                    // For Gender
                    FormBuilderDropdown<String>(
                      name: "gender",
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Sex',
                      ),
                      initialValue: initialValues["gender"],
                      items: ['Male', 'Female']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 8),

                    // For Contact Information
                    FormBuilderTextField(
                      name: "contactInfo",
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address',
                      ),
                      initialValue: initialValues["contactInfo"] as String,
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isPerforming
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        bool isValid = _formKey.currentState!.validate();
                        final inputs = _formKey.currentState!.instantValue;

                        if (isValid) {
                          setState(() {
                            _isPerforming = true;
                          });

                          final newPatient = Patient(
                            id: widget.patient?.id ?? '',
                            name: inputs["name"] as String,
                            age: int.parse(inputs["age"] as String),
                            gender: inputs["gender"] as String,
                            contactInfo: inputs["contactInfo"] as String,
                          );

                          if (widget.patient == null) {
                            // Add new patient
                            context.read<PatientCubit>().addPatient(newPatient);
                          } else {
                            // Update existing patient
                            context
                                .read<PatientCubit>()
                                .editPatient(newPatient);
                          }
                        }
                      },
                      child: _isPerforming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : Text(buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
