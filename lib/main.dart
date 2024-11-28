import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_metrics_tracker/core/services/injection_container.dart';
import 'package:health_metrics_tracker/global_theme_data.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/view_all_patient_page.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'firebase_options.dart';
import 'healthmetric managment/presentation/view_all_health_metric_page.dart';
import 'profile_page.dart'; // Import ProfilePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<HealthMetricCubit>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<PatientCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Health Metrics Tracker',
        themeMode: ThemeMode.light,
        theme: GlobalThemeData.lightThemeData,
        home: const MyHomePage(title: "Health Metrics Tracker"),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Health Metrics Page
    ViewAllHealthMetricsPage(
      healthMetric: HealthMetric(
        id: 'sample-id',
        patientId: 'sample-patient-id',
        date: DateTime.now(),
        systolicBP: 120,
        diastolicBP: 80,
        heartRate: 70,
        weight: 70.0,
        bloodSugar: 90.0,
      ),
    ),
    // Patients List Page
    const ViewAllPatientsPage(
      patients: [],
    ),
    // Profile Page
    const ProfilePage(), // Ensure this is correctly added
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Switch between pages
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change the index to switch pages
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: "Health Metrics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Patients",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
