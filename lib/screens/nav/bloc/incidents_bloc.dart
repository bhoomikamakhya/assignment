import 'package:assignment/screens/nav/bloc/incidents_event.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
class IncidentsBloc extends Bloc<IncidentEvent, List<Map<String, dynamic>>> {
  IncidentsBloc() : super([]);

  @override
  Stream<List<Map<String, dynamic>>> mapEventToState(IncidentEvent event) async* {
    if (event is FetchIncidentsEvent) {
      final incidents = await loadIncidentsFromAssets();
      yield incidents;
    }
  }

  Future<List<Map<String, dynamic>>> loadIncidentsFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/incidents.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<Map<String, dynamic>>();
  }
}
class IncidentListTile extends StatefulWidget {
  final Map<String, dynamic> incident;
  final Function onLongPress;

  const IncidentListTile({
    required this.incident,
    required this.onLongPress,
  });

  @override
  _IncidentListTileState createState() => _IncidentListTileState();
}

class _IncidentListTileState extends State<IncidentListTile> {
  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    final incident = widget.incident;
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isLongPressed = !isLongPressed;
        });
        widget.onLongPress(incident, isLongPressed);
      },
      child: Container(
        color: isLongPressed ? Colors.blue : Colors.white, // Change color based on long press
        padding: const EdgeInsets.all(16.0),
        child: Text(
          incident['title'],
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}