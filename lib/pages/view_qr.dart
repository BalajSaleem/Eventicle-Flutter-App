import 'package:exodus/models/Activity.dart';
import 'package:exodus/models/Person.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeViewer extends StatelessWidget {

  final Activity activity;

  const QrCodeViewer({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Activiy's QR Code",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2,
                fontSize: 24,
                fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 80,),
            QrImage(
              data: 'You are registered for: \n ${activity.title} \n from: ${activity.startDate} \n till:  ${activity.endDate} \n at: ${activity.address}',
              version: QrVersions.auto,
              size: 300.0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ],
        ),
      ),

    );
  }
}
