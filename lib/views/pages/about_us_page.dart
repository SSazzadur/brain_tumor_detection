import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "About Us",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/brain.webp'),
                const SizedBox(height: 20),
                const Text(
                  "A brain tumor detection app which detects 3 different types of brain tumor and also analyses whether a operson has a brain tumor or not.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  "This app predicts the tumor with the help of the 'densenet' model with an overall accuracy of 90%.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  "Made By:",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Kukil Bharadwaj (190310007024)\nManash Kar (190310007027)\nSazzadur Rahman (190310007043)",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Guided By:",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Manjula Kalita (Assistant Professor)",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
