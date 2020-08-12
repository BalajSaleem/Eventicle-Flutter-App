import './Person.dart';

class Activity{
  int id;
  String title;
  String startDate ;
  String endDate;
  int quota;
  String description;
  String address;
  double lat;
  double lng;
  List<Person> participants;

  Activity({this.id, this.title, this.startDate, this.endDate, this.quota,
    this.description, this.address, this.lat, this.lng, this.participants});


  @override
  String toString() {
    return 'Activity{id: $id, title: $title, startDate: $startDate, endDate: $endDate, quota: $quota, description: $description, address: $address, lat: $lat, lng: $lng}';
  }

  Activity.fromJson(Map<String, dynamic> json):
        id = json['id'],
        title = json['title'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        quota = json['quota'],
        description = json['description'],
        address = json['address'],
        lat = json['lat'],
        lng = json['lng'];
        //participants = json['participants'];
}



