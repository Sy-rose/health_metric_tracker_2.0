import 'package:flutter/material.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';

class HealthMetricRow extends StatelessWidget {
  final HealthMetric healthMetric;
  final VoidCallback onTap;

  const HealthMetricRow({
    super.key,
    required this.healthMetric,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        onTap: onTap,
        title: Text(
          'Date: ${healthMetric.date.toLocal().toString().split(' ')[0]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Systolic BP: ${healthMetric.systolicBP} mmHg'),
            Text('Diastolic BP: ${healthMetric.diastolicBP} mmHg'),
            Text('Heart Rate: ${healthMetric.heartRate} bpm'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
