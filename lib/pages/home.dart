import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exodus/models/Activity.dart';
import 'package:exodus/components/activity_card.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String baseUrl = 'http://139.179.202.8:8080/api/v1/';
  int personId = 5; //THIS IS A DUMMY ID, REPLACE THIS LATER

  void fetchRemainingUnregisteredActivities() async{
    http.Response response = await http.get('$baseUrl/eventsNotRegisteredRemaining/$personId');
    List<dynamic> data = json.decode(response.body);
    setState(() {
      activities = (data.map((activity) => Activity.fromJson(activity))).toList();
    });
  }

  void fetchAllEvents() async{
    http.Response response = await http.get('$baseUrl/events/');
    List<dynamic> data = json.decode(response.body);
    setState(() {
      activities = (data.map((activity) => Activity.fromJson(activity))).toList();
    });
  }

  void fetchRegisteredEvents() async{
    http.Response response = await http.get('$baseUrl/personEvents/$personId');
    List<dynamic> data = json.decode(response.body);
    setState(() {
      activities = (data.map((activity) => Activity.fromJson(activity))).toList();
    });
  }

  void applyForActivity(context, eventId) async{
    http.Response response = await http.put('$baseUrl/eventAddPerson/$eventId/$personId');
    if(response.statusCode == 200){
      _showToast(context, 'Applied For Event Successfully!');
    }
    else{
      _showToast(context, 'Error Applying for this event!');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

    switch (_selectedNavIndex) {
      case 0:
        fetchRemainingUnregisteredActivities();
        canApply = true;
        break;
      case 1:
        fetchAllEvents();
        setState(() {
          canApply = false;
        });
        break;
      case 2:
        fetchRegisteredEvents();
        setState(() {
          canApply = false;
        });
        break;
    }

  }

  @override
  void initState() {
    super.initState();
    activities.clear();
    fetchRemainingUnregisteredActivities();
  }

  List<Activity> activities = [
    Activity(id: 1, title: "Springo Jingo", startDate: "10/05/2020", endDate: "11/05/2020", quota: 30,
      description: "A tutorial for beginners to get their hands on Spring", lat: 39.907467, lng: 32.802582 , address: "Tubitak, Main Road, Karachi",),
    Activity(id: 2, title: "Reacto Sheacto", startDate: "12/05/2020", endDate: "15/05/2020", quota: 50,
      description: "A tutorial for beginners to get their hands on React", lat: 39.907467, lng: 32.802582 , address: "Tubitak, Main Road, Karachi",)
  ];
  int _selectedNavIndex = 0;
  bool canApply = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView (
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: (activities.isEmpty) ?
          Center(child: Text('No activities available')) :  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activities.map((activity) => ActivityCard(
                activity: activity,
                apply: (){
                  this.setState(() {
                    activities.remove(activity);
                    applyForActivity(context, activity.id); });
                },
                applyEnabled: canApply,
              )).toList()
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text('Available Events'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            title: Text('All Events'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            title: Text('Registered Events'),
          ),
        ],
        currentIndex: _selectedNavIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showToast(BuildContext context,String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }


}