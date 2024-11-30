// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/core/widgets/empty_state_list.dart';
import 'package:health_metrics_tracker/core/widgets/error_state_list.dart';
import 'package:health_metrics_tracker/core/widgets/loading_state_circular_progress.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/add_edit_health_metric_page.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';
import 'package:intl/intl.dart';

class ViewAllHealthMetricsPage extends StatefulWidget {
  const ViewAllHealthMetricsPage(
      {super.key, required HealthMetric healthMetric});

  @override
  State<ViewAllHealthMetricsPage> createState() =>
      _ViewAllHealthMetricsPageState();
}

class _ViewAllHealthMetricsPageState extends State<ViewAllHealthMetricsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch all health metrics when this page loads
    context.read<HealthMetricCubit>().getAllHealthMetrics();
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
        title: const Text("Health Metrics"),
      ),
      body: BlocBuilder<HealthMetricCubit, HealthMetricState>(
        builder: (context, state) {
          if (state is HealthMetricLoading) {
            return const LoadingStateCircularProgress();
          } else if (state is HealthMetricLoaded) {
            if (state.healthMetrics.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/Designer.png',
                title: 'No health metrics found',
                description: 'Tap the "+" button to add new health metrics.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.healthMetrics.length,
              itemBuilder: (context, index) {
                final currentMetric = state.healthMetrics[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(currentMetric.date)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Systolic: ${currentMetric.systolicBP}, "
                      "Diastolic: ${currentMetric.diastolicBP}, "
                      "Heart Rate: ${currentMetric.heartRate}",
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (_) => serviceLocator<HealthMetricCubit>(),
                            child: AddEditHealthMetricPage(
                                healthMetric: currentMetric),
                          ),
                        ),
                      );

                      context.read<HealthMetricCubit>().getAllHealthMetrics();

                      if (result is String) {
                        final snackBar = SnackBar(content: Text(result));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is HealthMetricError) {
            return ErrorStateList(
              imageAssetName: 'assets/pngegg.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<HealthMetricCubit>().getAllHealthMetrics();
              },
              message: 'Error fetching health metrics. Tap to retry.',
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/Designer.png',
              title: 'No health metrics available',
              description: "Tap '+' to add a new health metric.",
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => serviceLocator<HealthMetricCubit>(),
                child: const AddEditHealthMetricPage(healthMetric: null),
              ),
            ),
          );

          context.read<HealthMetricCubit>().getAllHealthMetrics();

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