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
  Person maker;
  List<Person> participants;

  Activity({this.id, this.title, this.startDate, this.endDate, this.quota,
    this.description, this.address, this.lat, this.lng, this.maker, this.participants});


  @override
  String toString() {
    return 'Activity{id: $id, title: $title, startDate: $startDate, endDate: $endDate, quota: $quota, description: $description, address: $address, lat: $lat, lng: $lng}';
  }

  Activity.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    quota = json['quota'];
    description = json['description'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];

    maker = json['maker'] != null ? new Person.fromJson(json['maker']) : null;
    if (json['participants'] != null) {
      participants = new List<Person>();
      json['participants'].forEach((v) {
        participants.add(new Person.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['quota'] = this.quota;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    //dont need to add participants and maker for new activity at the moment
//    if (this.maker != null) {
//      data['maker'] = this.maker.toJson();
//    }
//    if (this.participants != null) {
//      data['participants'] = this.participants.map((v) => v.toJson()).toList();
//    }
    return data;
  }

}



