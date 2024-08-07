import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import '../pages/Home.dart';
import 'package:intl/intl.dart';
class EventCardWithActions extends StatefulWidget {
  const EventCardWithActions({super.key});
  @override
  _EventCardWithActionsState createState() => _EventCardWithActionsState();
}
class _EventCardWithActionsState extends State<EventCardWithActions> {
  bool liked=false;
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          defaultChild: const Center(child: LinearProgressIndicator()),
          query: FirebaseDatabase.instance.ref().root.child("events/clubs-name"),
          itemBuilder: (context, snapshot, animation, index) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      snapshot.child("imageUrl").value.toString(), // Use '!' for null-safe access
                      height: 300.0,
                      width: MediaQuery.of(context).size.width
                    )
                    ,
                    SizedBox(height: 10.0),
                    Text(
                      snapshot.child("title").value.toString(),
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0),
                    Text(snapshot.child("description").value.toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Reaction buttons (replace with your preferred icons)
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up_alt_outlined),
                              onPressed: () async{
                                int likes =int.parse(snapshot.child("likes").value.toString());
                                if(!liked) {
                                  await FirebaseDatabase.instance.ref().root.child("events/clubs-name/${snapshot.key.toString()}/likes").set(++likes);
                                  setState(() {
                                  liked=true;
                                });
                                }
                                else{
                                  await FirebaseDatabase.instance.ref().root.child("events/clubs-name/${snapshot.key.toString()}/likes").set(--likes);
                                  setState(() {
                                    liked=false;
                                  });
                                }
                              },
                            ),
                            Text('${snapshot.child("likes").value.toString()}'), // Display like count
                          ],
                        ),
                        // Notification button
                        IconButton(
                          icon: Icon(Icons.notifications_none),
                          onPressed: () {
                            setState(() {
                              // Implement notification scheduling code here
                            });
                          },
                        ),
                      ],
                    ),
                    // Deadline badge (optional)
                    Container(
                      padding: EdgeInsets.all(5.0),
                      color: Colors.amberAccent,
                      child: Text(
                        'Deadline: ${(DateFormat('dd/MM/yy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse((snapshot.child("deadline").value.toString())))))}',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
  }

}
