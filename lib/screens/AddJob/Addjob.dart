import 'package:flutter/material.dart';
import 'package:cbl/cbl.dart';
import 'package:assignment/screens/nav/stack_view_screen.dart';
import 'package:assignment/screens/nav/bloc/incidents_bloc.dart';

import '../nav/widgets/stack_view_widget.dart';


class AddJob extends StatefulWidget {
  @override
  _AddJobState createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  TextEditingController positionController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController idController=TextEditingController();
  TextEditingController locationController=TextEditingController();
  TextEditingController employmentTypeController=TextEditingController();
  TextEditingController skillsRequiredController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 20, 64, 110),
        title: Text('Add New Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(
          children: [

            TextFormField(
              controller: companyController,
              decoration: InputDecoration(
                labelText: 'Company',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: employmentTypeController,
              decoration: InputDecoration(
                labelText: 'Employment Type',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: positionController,
              decoration: InputDecoration(
                labelText: 'Position',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: skillsRequiredController,
              decoration: InputDecoration(
                labelText: 'Skills Required',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 20, 64, 110))),
              onPressed: () {
                if (positionController.text == "" ||
                    idController.text == "" ||
                    locationController.text=="" ||
                    companyController.text == "" ||
                    descriptionController.text == "") {
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Data Required'),
                      content: Text('Fill all the mandatory fields'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),

                        ),
                      ],
                    );
                  },
                  );
                }
                else {
                  print('Position: ${positionController.text}');
                  print('Company: ${companyController.text}');
                  print('Description: ${descriptionController.text}');

                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Future<void> saveJobs(List<Job> JobsList) async {
    try {
      final database = await Database.openAsync('my-database');

      for (final job in JobsList) {
        final doc = MutableDocument();
        final dictionary = MutableDictionary();
        dictionary.setString(job.company, key: 'company');
        dictionary.setString(job.description, key: 'description');
        dictionary.setInteger(job.id, key: 'ID');
        dictionary.setString(job.location, key: 'location');
        dictionary.setString(job.position, key: 'position');
        doc.setDictionary(key: 'data', dictionary);

        await database.saveDocument(doc);

        print('Job saved with id: ${doc.id}');
      }

      await database.close();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jobs saved successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save jobs: $e'),
        ),
      );
    }
  }
}