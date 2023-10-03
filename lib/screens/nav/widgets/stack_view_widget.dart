
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:assignment/screens/AddJob/Addjob.dart';
class Job{
  final String company;
  final String description;
  final String employmentType;
  final int id;
  final String location;
  final String position;
  final List<String> skillsRequired;

  Job({
    required this.company,
    required this.description,
    required this.employmentType,
    required this.id,
    required this.location,
    required this.position,
    required this.skillsRequired,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      company: json['company'] ?? '',
      description: json['description'] ?? '',
      employmentType: json['employmentType'] ?? '',
      id: json['id'] ?? 0,
      location: json['location'] ?? '',
      position: json['position'] ?? '',
      skillsRequired: List<String>.from(json['skillsRequired'] ?? []),
    );
  }
}

class JobsListView extends StatelessWidget {
  // final List<Job> apiData; // API data
  // final List<Job> fetchedData;

  JobsListView({data});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job>? data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Job>> fetchJobs() async {
    final response = await http.get(Uri.parse('https://mock-json-service.glitch.me/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      final apiJobsList= jsonResponse.map((job) => new Job.fromJson(job)).toList();
      return apiJobsList;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
  void fetchAndSave() async{
    try{
      final JobsList = await fetchJobs();
      //await saveJobs(JobsList);
    }
    catch(e){

    }
  }

  ListView _jobsListView(combinedData) {
    return ListView.builder(
        itemCount: combinedData.length,
        itemBuilder: (context, id) {
          return Card(
              child: _tile(combinedData[id].position, combinedData[id].company, combinedData[id].description ,combinedData[id].location,Icons.work),
          ) ;
        });
  }

  ListTile _tile(String title, String subtitle, String description, String Location, IconData icon) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    trailing: Text(Location),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
  );
}