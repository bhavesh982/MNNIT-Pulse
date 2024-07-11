import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

class EventCard extends StatefulWidget {
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      scrollDirection: Axis.horizontal,
      controller: _controller, // Assign the scroll controller
      shrinkWrap: true,
      defaultChild: const Center(child: LinearProgressIndicator()),

      query: FirebaseDatabase.instance.ref().root.child("events/clubs-name"),
      itemBuilder: (context, snapshot, animation, index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, // Allow container to fill available width
                      height: 110.0, // Adjust height as needed
                      child: Image.network(
                        snapshot.child("imageUrl").value.toString(),
                        fit: BoxFit.cover, // Resize to cover container while maintaining aspect ratio
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      snapshot.child("title").value.toString(),
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      snapshot.child("description").value.toString(),
                      style: TextStyle(fontSize: 12.0),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
