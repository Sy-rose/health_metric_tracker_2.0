import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/add_edit_health_metric_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';
import 'package:intl/intl.dart';

class ViewHealthMetricPage extends StatefulWidget {
  final HealthMetric healthMetric;

  const ViewHealthMetricPage({
    super.key,
    required this.healthMetric,
  });

  @override
  State<ViewHealthMetricPage> createState() => _ViewHealthMetricPageState();
}

class _ViewHealthMetricPageState extends State<ViewHealthMetricPage> {
  late HealthMetric _currentHealthMetric;

  @override
  void initState() {
    super.initState();
    _currentHealthMetric = widget.healthMetric;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HealthMetricCubit, HealthMetricState>(
      listener: (context, state) {
        if (state is HealthMetricDelete) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Health Metric Deleted");
        } else if (state is HealthMetricError) {
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
            "Back To Health Metrics List",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Icon(Icons.health_and_safety, size: 150, color: Colors.blue[900]),
              Text(
                "Date: ${DateFormat.yMMMd().format(_currentHealthMetric.date)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Systolic BP: ${_currentHealthMetric.systolicBP} mmHg",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Diastolic BP: ${_currentHealthMetric.diastolicBP} mmHg",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Heart Rate: ${_currentHealthMetric.heartRate} bpm",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Weight: ${_currentHealthMetric.weight} kg",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                "Blood Sugar: ${_currentHealthMetric.bloodSugar} mg/dL",
                style: const TextStyle(fontSize: 16),
              ),
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
                              create: (context) =>
                                  serviceLocator<HealthMetricCubit>(),
                              child: AddEditHealthMetricPage(
                                healthMetric: _currentHealthMetric,
                              ),
                            ),
                          ),
                        );

                        if (result.runtimeType == HealthMetric) {
                          setState(() {
                            _currentHealthMetric = result;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Edit Health Metric"),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        const snackBar = SnackBar(
                          content: Text("Deleting Health Metric..."),
                          duration: Duration(seconds: 9),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        context
                            .read<HealthMetricCubit>()
                            .deleteHealthMetric(widget.healthMetric as String);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Delete Health Metric"),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
