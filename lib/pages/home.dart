import 'package:exodus/models/Person.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exodus/models/Activity.dart';
import 'package:exodus/components/activity_card.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class Home extends StatefulWidget {
  final Person user;

  const Home({ this.user}) ;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String baseUrl = 'http://139.179.202.8:8080/api/v1/';
  List<Activity> activities = [
    Activity(id: 1, title: "A Placeholder", startDate: "10/05/2020", endDate: "11/05/2020", quota: 30,
      description: "If you see this, you probably did not connect to the internet yet",
      lat: 39.907467, lng: 32.802582 , address: "Tubitak, Main Road, Karachi"),
  ];
  int _selectedNavIndex = 0;
  bool canApply = true;
  final GlobalKey<ScrollableState> globalScrollKey = new GlobalKey<ScrollableState>();
  StompClient stompClient;


  void fetchRemainingUnregisteredActivities() async{
    http.Response response = await http.get('$baseUrl/eventsNotRegisteredRemaining/${widget.user.id}');
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
    http.Response response = await http.get('$baseUrl/personEvents/${widget.user.id}');
    List<dynamic> data = json.decode(response.body);
    setState(() {
      activities = (data.map((activity) => Activity.fromJson(activity))).toList();
    });
  }

  void applyForActivity(context, event) async{
    http.Response response = await http.put('$baseUrl/eventAddPerson/${event.id}/${widget.user.id}');
    if(response.statusCode == 200){
      print('EVENT ID: ${event.id}' );
      print(activities);
      //print('/app/applyToOfficer/${activities.firstWhere((activity) => activity.id == event.id).maker.id}/${event.id}/${widget.user.id}');
      stompClient.send(destination: '/app/applyToOfficer/${activities.firstWhere((activity) => activity.id == event.id).maker.id}/${event.id}/${widget.user.id}');
      setState(() {
        activities.remove(event);
      });
      _showToast(context, 'Applied For Event Successfully!');
    }
    else{
      _showToast(context, 'Error Applying for this event!');
    }
  }

  void _showToast(BuildContext context,String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  dynamic onConnect(StompClient client, StompFrame frame) {
    print("Oh my god, were connected");
    client.subscribe(
        destination: '/topic/eventAnnouncements',
        callback: (StompFrame frame) {
          final result = json.decode(frame.body) as Map;
          _showToast(globalScrollKey.currentContext, result['content']);
          _onNavItemTapped(_selectedNavIndex);
        });
  }

  void startStomping(){
    stompClient = StompClient(
        config: StompConfig.SockJS(
            url: 'http://139.179.202.8:8080/eventicle/',
            onConnect: onConnect,
            onWebSocketError: (dynamic error) => print(error.toString())
        )
    );

    stompClient.activate();
  }

  //Navbar navigation
  void _onNavItemTapped(int index) {
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
    startStomping();
//    new Future.delayed(Duration.zero,() {
//    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events for you, ${widget.user.name}'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Builder(
        builder: (context) =>  SingleChildScrollView (
          key: globalScrollKey,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: (activities.isEmpty) ?
          Center(child: Text('No activities available')) :
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activities.map((activity) => ActivityCard(
                activity: activity,
                apply: () {applyForActivity(context, activity); },
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
        onTap: _onNavItemTapped,
      ),
    );
  }


}