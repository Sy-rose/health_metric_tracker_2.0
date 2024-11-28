import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/Designer.png'),
        ),
        title: const Text("HealthMetric"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              Image.asset("assets/pic.png", width: 50, height: 50),
              const SizedBox(
                width: 10,
              ),
              const Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Carlo Valdez",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Bachelor of Science in Computer Science",
                      softWrap: true,
                      overflow: TextOverflow
                          .visible, // Optional: Handles long text gracefully
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              Image.asset("assets/sairose.png", width: 60, height: 60),
              const SizedBox(
                width: 10,
              ),
              const Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sairose Eder",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Bachelor of Science in Computer Science",
                      softWrap: true,
                      overflow: TextOverflow
                          .visible, // Optional: Handles long text gracefully
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
