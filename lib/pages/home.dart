import 'package:exodus/models/Person.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:exodus/models/Activity.dart';
import 'package:exodus/components/activity_card.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:qrscan/qrscan.dart' as scanner;

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
  bool canViewQr = false;
  bool isCorporateUser = false;
  final GlobalKey<ScrollableState> globalScrollKey = new GlobalKey<ScrollableState>();

  StompClient stompClient;
  String stompDestination = '/topic/eventAnnouncements';

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

  void fetchCreatedEvents() async{
    http.Response response = await http.get('$baseUrl/officerEvents/${widget.user.id}');
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

  void viewActivityQrCode(event){

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
        destination: stompDestination,
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

    if(!isCorporateUser){
      switch (_selectedNavIndex) {
        case 0:
          fetchRemainingUnregisteredActivities();
          canApply = true;
          canViewQr = false;
          break;
        case 1:
          fetchAllEvents();
          setState(() {
            canApply = false;
            canViewQr = false;
          });
          break;
        case 2:
          fetchRegisteredEvents();
          setState(() {
            canApply = false;
            canViewQr = true;
          });
          break;
      }
    }
    else{
      switch (_selectedNavIndex) {
        case 0:
          fetchCreatedEvents();
          canApply = false;
          canViewQr = true;
          break;
        case 1:
          print('SHOW CHARTS!');
          _showToast(globalScrollKey.currentContext, "Charts will apear here!");
          //TODO: ADD CHARTS
          break;
      }
    }


  }

  @override
  void initState() {
    super.initState();
    activities.clear();
    isCorporateUser = (widget.user?.corporation != null);
    _onNavItemTapped(0);
    if(isCorporateUser){
      stompDestination = '/topic/officer/${widget.user.id}';
    }
    startStomping();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events for ${widget.user.name}'),
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
                canApply: canApply,
                canViewQr: canViewQr,
              )).toList()
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: (!isCorporateUser)
            ?
        const <BottomNavigationBarItem>[
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
        ]
            :
        const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text('Created Events'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Charts'),
          ),
        ],
        currentIndex: _selectedNavIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: _onNavItemTapped,
      ),
      floatingActionButton: isCorporateUser ?
      FloatingActionButton(
        onPressed: () async {
          var result = await scanner.scan();
          print(result);
          _showDialog(title: "Activity Details", body: result);
        },
        child: Icon(Icons.camera),
        backgroundColor: Colors.greenAccent,
      )
          :
          null,
    );
  }


  Future<void> _showDialog({String title, String body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}