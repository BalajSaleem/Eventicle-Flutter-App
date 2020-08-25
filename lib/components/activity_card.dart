import 'package:exodus/models/Person.dart';
import 'package:exodus/pages/view_qr.dart';
import 'package:flutter/material.dart';
import 'package:exodus/models/Activity.dart';
import 'package:exodus/pages/view_location.dart';


class ActivityCard extends StatelessWidget {
  final Activity activity;
  final Person user;
  final Function apply;
  final bool canApply;
  final bool canViewQr;

  ActivityCard({this.activity, this.user, this.apply, this.canApply, this.canViewQr});

  static const TextStyle greyedStyle = TextStyle(
    color: Colors.grey,
    letterSpacing: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('TITLE', style: greyedStyle),
            SizedBox(height: 10),
            Text(
              activity.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green[300],
                  letterSpacing: 2,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('START DATE', style: greyedStyle),
                    SizedBox(height: 10),
                    Text(
                      activity.startDate,
                      style: TextStyle(
                          color: Colors.green[300],
                          letterSpacing: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('END DATE', style: greyedStyle),
                    SizedBox(height: 10),
                    Text(
                      activity.endDate,
                      style: TextStyle(
                          color: Colors.green[300],
                          letterSpacing: 2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('DESCRIPTION', style: greyedStyle),
            SizedBox(height: 10),
            Text(
              activity.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green[300],
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text('QUOTA', style: greyedStyle),
            SizedBox(height: 10),
            Text(
              '${activity.quota}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green[300],
                letterSpacing: 2,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text('ADDRESS', style: greyedStyle),
            SizedBox(height: 10),
            Text(
              activity.address,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green[300],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/location', arguments: activity);
                    },
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.grey[400],
                    ),
                    label: Text("Location",
                        style: TextStyle(
                          color: Colors.grey[400],
                        ))),
                canApply
                    ? FlatButton.icon(
                    onPressed: apply,
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey[400],
                    ),
                    label: Text("Apply",
                        style: TextStyle(
                          color: Colors.grey[400],
                        )))
                    : SizedBox(width: 1,),
                canViewQr
                    ? FlatButton.icon(
                  onPressed: () {
                    var route = new MaterialPageRoute(builder: (BuildContext context) => new QrCodeViewer(activity: activity, user: user));
                    Navigator.of(context).push(route);
                    },
                    icon: Icon(
                      Icons.casino,
                      color: Colors.grey[400],
                    ),
                    label: Text("QR Code",
                        style: TextStyle(
                          color: Colors.grey[400],
                        )))
                    : SizedBox(width: 1,)
              ],
            ),

          ],
        ),
      ),
    );
  }
}
