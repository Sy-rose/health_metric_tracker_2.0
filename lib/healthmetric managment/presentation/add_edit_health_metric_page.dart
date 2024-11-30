import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';

class AddEditHealthMetricPage extends StatefulWidget {
  final HealthMetric? healthMetric;

  const AddEditHealthMetricPage({super.key, this.healthMetric});

  @override
  State<AddEditHealthMetricPage> createState() =>
      _AddEditHealthMetricPageState();
}

class _AddEditHealthMetricPageState extends State<AddEditHealthMetricPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.healthMetric == null
        ? "Add New Health Metric"
        : "Edit Health Metric";
    String buttonLabel = widget.healthMetric == null
        ? "Add Health Metric"
        : "Update Health Metric";

    final initialValues = {
      'patientId': widget.healthMetric?.patientId ?? '',
      'date': widget.healthMetric?.date,
      'systolicBP': widget.healthMetric?.systolicBP ?? '',
      'diastolicBP': widget.healthMetric?.diastolicBP ?? '',
      'heartRate': widget.healthMetric?.heartRate ?? '',
      'weight': widget.healthMetric?.weight ?? '',
      'bloodSugar': widget.healthMetric?.bloodSugar ?? '',
    };

    return BlocListener<HealthMetricCubit, HealthMetricState>(
      listener: (context, state) {
        if (state is HealthMetricAdded) {
          Navigator.pop(context, "Health Metric Added Successfully.");
        } else if (state is HealthMetricError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is HealthMetricUpdated) {
          Navigator.pop(context, state.newHealthMetric);
        } else if (state is HealthMetricDelete) {
          Navigator.pop(context, "Health Metric Deleted Successfully.");
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(appBarTitle)),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: _formKey,
                initialValue: initialValues,
                child: ListView(padding: const EdgeInsets.all(8.0), children: [
                  // patientId
                  FormBuilderTextField(
                    name: "patientId",
                    decoration: InputDecoration(labelText: "Patient ID"),
                    initialValue: initialValues["patientId"] as String,
                    validator: FormBuilderValidators.required(),
                  ),

                  // date
                  FormBuilderDateTimePicker(
                    name: "date",
                    decoration: InputDecoration(labelText: 'Date'),
                    inputType: InputType.date,
                    initialValue: initialValues["date"] as DateTime?,
                  ),

                  // systolic BP
                  FormBuilderTextField(
                    name: "systolicBP",
                    decoration: InputDecoration(labelText: "Systolic BP"),
                    initialValue: initialValues["systolicBP"] as String,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),

                  // diastolic BP
                  FormBuilderTextField(
                    name: "diastolicBP",
                    decoration: InputDecoration(labelText: "Diastolic BP"),
                    initialValue: initialValues["diastolicBP"] as String,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),

                  // heart rate
                  FormBuilderTextField(
                    name: "heartRate",
                    decoration: InputDecoration(labelText: "Heart Rate"),
                    initialValue: initialValues["heartRate"] as String,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),

                  // weight
                  FormBuilderTextField(
                    name: "weight",
                    decoration: InputDecoration(labelText: "Weight"),
                    initialValue: initialValues["weight"] as String,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),

                  // blood sugar
                  FormBuilderTextField(
                    name: "bloodSugar",
                    decoration: InputDecoration(labelText: "Blood Sugar"),
                    initialValue: initialValues["bloodSugar"] as String,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                ]),
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

                        final newHealthMetric = HealthMetric(
                          id: widget.healthMetric?.id ?? '',
                          patientId: inputs["patientId"] as String,
                          date: inputs["date"] as DateTime,
                          systolicBP:
                              double.tryParse(inputs["systolicBP"] as String) ??
                                  0.0,
                          diastolicBP: double.tryParse(
                                  inputs["diastolicBP"] as String) ??
                              0.0,
                          heartRate:
                              double.tryParse(inputs["heartRate"] as String) ??
                                  0.0,
                          weight: double.tryParse(inputs["weight"] as String) ??
                              0.0,
                          bloodSugar:
                              double.tryParse(inputs["bloodSugar"] as String) ??
                                  0.0,
                        );

                        if (widget.healthMetric == null) {
                          context
                              .read<HealthMetricCubit>()
                              .addHealthMetric(newHealthMetric);
                        } else {
                          context
                              .read<HealthMetricCubit>()
                              .editHealthMetric(newHealthMetric);
                        }
                      }
                    },
                    child: _isPerforming
                        ? const CircularProgressIndicator()
                        : Text(buttonLabel),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
