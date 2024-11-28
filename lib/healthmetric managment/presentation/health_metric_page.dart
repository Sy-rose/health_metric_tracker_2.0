import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';
import 'add_edit_health_metric_page.dart';  // Import the AddEditHealthMetricPage

class HealthMetricPage extends StatelessWidget {
  const HealthMetricPage({super.key, required HealthMetric healthMetric});

  @override
  Widget build(BuildContext context) {
    // Triggering the cubit to get all health metrics when the page loads
    context.read<HealthMetricCubit>().getHealthMetrics();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Metrics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the Add/Edit Health Metric Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditHealthMetricPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HealthMetricCubit, HealthMetricState>(
        builder: (context, state) {
          if (state is HealthMetricLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HealthMetricLoaded) {
            return ListView.builder(
              itemCount: state.healthMetrics.length,
              itemBuilder: (context, index) {
                final healthMetric = state.healthMetrics[index];
                return ListTile(
                  title: Text('Systolic: ${healthMetric.systolicBP} / Diastolic: ${healthMetric.diastolicBP}'),
                  subtitle: Text('Heart Rate: ${healthMetric.heartRate} bpm, Weight: ${healthMetric.weight} kg'),
                  trailing: Text('Date: ${healthMetric.date.toLocal()}'),
                  onTap: () {
                    // Navigate to the Add/Edit Health Metric Page for editing
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditHealthMetricPage(
                          healthMetric: healthMetric,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is HealthMetricError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
