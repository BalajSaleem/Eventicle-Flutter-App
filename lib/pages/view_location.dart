import 'dart:collection';

import 'package:exodus/models/Activity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMapLocation extends StatefulWidget {
  @override
  _ViewMapLocationState createState() => _ViewMapLocationState();
}

class _ViewMapLocationState extends State<ViewMapLocation> {
  Set<Marker> markers = HashSet<Marker>();
  Activity activity;
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
    setState(() {
      markers.add(Marker(
          markerId: MarkerId('0'),
          position: LatLng(activity.lat, activity.lng),
          infoWindow: InfoWindow(
            title: activity.title,
            snippet: activity.description,
          )
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      activity = ModalRoute.of(context).settings.arguments;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Location of ${activity.title}'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
        target: LatLng(activity.lat, activity.lng),
        zoom: 18,
      ),
      markers: markers,
      ),
    );
  }
}
