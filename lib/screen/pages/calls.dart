import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:call_log/call_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class calls extends StatefulWidget {
  const calls({super.key});

  @override
  State<calls> createState() => _callsState();
}

class _callsState extends State<calls> {
  String? last;//phone_no
  var type;
  var ct;
  var check = " ";
  String _input1 = '';//name
  String _input2 = '';//rating
  Iterable<CallLogEntry> _callLogEntries = [];

  @override
  void initState() {
    super.initState();
    _refreshCallLogEntries();
  }

  Future<void> _refreshCallLogEntries() async {
    final Iterable<CallLogEntry> entries = await CallLog.get();
    setState(() {
      _callLogEntries = entries;
    });
    CallLogEntry latestEntry = entries.elementAt(0);
    last = latestEntry.number;
    type = latestEntry.timestamp;
    if (last != check || type != ct) {
      print("yes");
      check = last!;
      ct = type;
      _showRatingDialogBox(last!);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.scale,
        title: 'Info',
        desc: 'Enter the name and rating',
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),//name
                onChanged: (value) {
                  setState(() {
                    _input1 = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rating ?/5'),//rating
                onChanged: (value) {
                  setState(() {
                    _input2 = value;
                  });
                },
              ),
            ],
          ),
        ),
        btnOkOnPress: () {
          print('Input 1: $_input1');
          print('Input 2: $_input2');
          // Store the rating in Firebase
          FirebaseFirestore.instance
              .collection('ratings')
              .doc(last)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              // Update the rating by taking the average
              Map<String, dynamic>? data = documentSnapshot.data()! as Map<String, dynamic>?;
              int rating = data!['rating'];
              int count = data['count'];
              int newRating = int.parse(_input2);
              int newCount = count + 1;
              int avgRating = ((rating * count) + newRating) ~/ newCount;
              FirebaseFirestore.instance
                  .collection('ratings')
                  .doc(last)
                  .update({'rating': avgRating, 'count': newCount});
            } else {
              // Add the phone_no to Firebase
              FirebaseFirestore.instance
                  .collection('ratings')
                  .doc(last)
                  .set({
                'name': _input1,
                'rating': int.parse(_input2),
                'count': 1,
              });
            }
          });
        },
      ).show();
    }
    Future.delayed(const Duration(seconds: 2), () => _refreshCallLogEntries());
  }
Future<void> _showRatingDialogBox(String phoneNo) async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('ratings').doc(phoneNo).get();
  if (documentSnapshot.exists) {
    // Retrieve the data from the document
    Map<String, dynamic>? data = documentSnapshot.data()! as Map<String, dynamic>?;
    String name = data!['name'];
    int rating = data['rating'];

    // Show the dialog box with the name and rating
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.scale,
      title: 'Rating for $name',
      desc: '$phoneNo has a rating of $rating/5',
      btnOkText: 'Ok',
      btnOkOnPress: () {},
    ).show();
  }
}
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: ListView.builder(
      itemCount: _callLogEntries.length,
      itemBuilder: (BuildContext context, int index) {
        final CallLogEntry entry = _callLogEntries.elementAt(index);
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('ratings').doc(entry.number!).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
              final int rating = data!['rating'];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(entry.callType.toString().substring(9, 10),style: TextStyle(color: Colors.white),),
                  backgroundColor: Colors.blueGrey,
                ),
                title: Text(entry.formattedNumber ?? ''),
                subtitle: Text(data['name'] ?? ''),
                trailing: Text('$rating/5'),
              );
            } else {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(entry.callType.toString().substring(9, 10),
                  style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color.fromARGB(255, 241, 131, 131),
                ),
                title: Text(entry.formattedNumber ?? ''),
                subtitle: Text(entry.name ?? ''),
              );
            }
          },
        );
      },
    ),
  );
}

}
 