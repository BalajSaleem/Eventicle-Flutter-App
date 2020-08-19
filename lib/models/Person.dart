class Person {
  int id;
  String name;
  String surname;
  String password;
  String email;
  String nationalId;
  String corporation;

  Person(
      {this.id,
        this.name,
        this.surname,
        this.password,
        this.email,
        this.nationalId,
        this.corporation});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    password = json['password'];
    email = json['email'];
    nationalId = json['nationalId'];
    corporation = json['corporation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['password'] = this.password;
    data['email'] = this.email;
    data['nationalId'] = this.nationalId;
    data['corporation'] = this.corporation;
    return data;
  }


}