import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';

class AddEditHealthMetricPage extends StatefulWidget {
  final HealthMetric? healthMetric;

  const AddEditHealthMetricPage({super.key, this.healthMetric});

  @override
  State<AddEditHealthMetricPage> createState() =>
      _AddEditHealthMetricPageState();
}

class _AddEditHealthMetricPageState extends State<AddEditHealthMetricPage> {
  final _formKey = GlobalKey<FormState>();
  late String _systolicBP, _diastolicBP, _heartRate;

  @override
  void initState() {
    super.initState();
    if (widget.healthMetric != null) {
      _systolicBP = widget.healthMetric!.systolicBP.toString();
      _diastolicBP = widget.healthMetric!.diastolicBP.toString();
      _heartRate = widget.healthMetric!.heartRate.toString();
    }
  }

  void _saveMetric() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final metric = HealthMetric(
        id: widget.healthMetric?.id ?? DateTime.now().toString(),
        patientId: 'sample-patient-id',
        date: DateTime.now(),
        systolicBP: double.parse(_systolicBP),
        diastolicBP: double.parse(_diastolicBP),
        heartRate: double.parse(_heartRate),
        weight: 70.0, // Placeholder
        bloodSugar: 90.0, // Placeholder
      );
      if (widget.healthMetric == null) {
        context.read<HealthMetricCubit>().addHealthMetric(metric);
      } else {
        context.read<HealthMetricCubit>().editHealthMetric(metric);
      }
      Navigator.pop(context, 'Saved Successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add/Edit Health Metric")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _systolicBP,
                decoration: const InputDecoration(labelText: 'Systolic BP'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _systolicBP = value!,
                validator: (value) => value!.isEmpty ? 'Please enter systolic BP' : null,
              ),
              TextFormField(
                initialValue: _diastolicBP,
                decoration: const InputDecoration(labelText: 'Diastolic BP'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _diastolicBP = value!,
                validator: (value) => value!.isEmpty ? 'Please enter diastolic BP' : null,
              ),
              TextFormField(
                initialValue: _heartRate,
                decoration: const InputDecoration(labelText: 'Heart Rate'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _heartRate = value!,
                validator: (value) => value!.isEmpty ? 'Please enter heart rate' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMetric,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
