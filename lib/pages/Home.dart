import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../widgets/eventCards.dart';
import '../widgets/eventcardswithactions.dart';
import 'addevents.dart';
String formatDate(DateTime date) {
  return DateFormat('MMM dd, yyyy').format(date); // Customize date format as needed
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Handle successful logout (optional)
      print('User logged out successfully');
      // Navigate to login screen or display a message (optional)
    } on FirebaseAuthException catch (e) {
      // Handle logout error
      print(e.message);
      // Show an error message to the user (optional)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(width: 10.0),
            Text('College Events'),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async{
           await logout();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality for events
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (c)=>AddEventPage()));
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              featuredEventsCarousel(context),
                  upcomingEventsList(context),
            ],
          )
      ),
    );
  }

  Widget featuredEventsCarousel(BuildContext context) {
    return Container(
      height: 210.0,
      // Adjust height as needed
      child: Flexible(child: EventCard()) // Use EventCard
      );
  }

  Widget upcomingEventsList(BuildContext context) {
    return EventCardWithActions(); // Use EventCardWithActions
  }

}

