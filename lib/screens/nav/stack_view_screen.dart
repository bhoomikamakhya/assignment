import 'package:assignment/screens/AddJob/Addjob.dart';
import 'package:assignment/screens/nav/widgets/stack_view_widget.dart';
import 'package:assignment/screens/nav/bloc/incidents_event.dart';
import 'package:assignment/screens/nav/bloc/incidents_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';
import 'package:assignment/screens/Login/Login.dart';
import 'package:provider/provider.dart';


class StackViewScreen extends StatefulWidget {
  final IncidentsBloc bloc;
  //final List<Map<String, dynamic>> apiData;


  StackViewScreen({required this.bloc});
  _StackViewScreenState createState() => _StackViewScreenState();
}

class _StackViewScreenState extends State<StackViewScreen> with WidgetsBindingObserver {
  List<Job> apiJobs =[];
  List<Job> fetchedData = [];
  List<Job> combinedData = [];

  Future<void> _fetchApiData() async {

    apiJobs = await JobsListView().fetchJobs();
  }

  Future<void> _fetchDataFromDatabase() async {
    fetchedData = await fetchedData;
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkLoginState();
    _fetchApiData();

  }

  Future<void> checkLoginState() async {
    final isLoggedIn = await SharedPreferencesHelper.isLoggedIn();
    if (!isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

    @override
    void dispose() {
      WidgetsBinding.instance.removeObserver(this);
      super.dispose();
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      if (state == AppLifecycleState.resumed) {
        final incidentsBloc = BlocProvider.of<IncidentsBloc>(context);
        incidentsBloc.add(FetchIncidentsEvent());
      }
    }
    @override
    Widget build(BuildContext context) {
      //final jobs = Provider.of<JobProvider>(context).jobs;
      final incidentsBloc = BlocProvider.of<IncidentsBloc>(context);
      final bottomNavigationBarItems = [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
      return BlocBuilder<IncidentsBloc, List<Map<String, dynamic>>>(
        builder: (context, incidents) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromARGB(255, 20, 64, 110),
              title: Row(
                  children: <Widget>[Text('Incident List'),
                  ]
              ),
              actions: [IconButton(onPressed: () async {
                await SharedPreferencesHelper.setLoggedIn(false);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              }, icon: Icon(Icons.exit_to_app))
              ],
            ),
            body: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Color.fromARGB(255, 20, 64, 110),
                    unselectedLabelColor: Colors.black38,
                    tabs: [
                      Tab(text: 'ALL'),
                      Tab(text: 'MINE'),
                      Tab(text: 'TEAM',)
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        JobsListView(),
                        Container(),
                        Container(), // Placeholder for Tab 2 content
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Add new job
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddJob()));
              },
              child: Icon(Icons.add),
            ),
          );
        },
      );
    }
  }