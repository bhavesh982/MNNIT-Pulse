import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.ref();
  final _picker = ImagePicker();
  final _storageReference = FirebaseStorage.instance.ref();
  File? _imageFile;
  String? _imageUrl;
  DateTime? _selectedDeadline;

  Future<void> _selectDeadline() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate!.year,
            pickedDate!.month,
            pickedDate!.day,
            pickedTime!.hour,
            pickedTime!.minute,
          );
        });
      }
    }
  }

  void addEventToDatabase() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    int likes = 50;
    final deadlineTimestamp = _selectedDeadline!.millisecondsSinceEpoch;
    // Generate a unique ID
    String uniqueId = await databaseReference.push().key!;

    // Create event data
    Map<String, dynamic> eventData = {
      'title': title,
      'description': description,
      'imageUrl': _imageUrl,
      'likes': likes,
      'deadline': deadlineTimestamp,
    };

    // Write data to Firebase Realtime Database
    await databaseReference.child('events/clubs-name/$uniqueId').set(eventData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event added successfully!'),
        ),
      );
      // Clear the form
      _formKey.currentState!.reset();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding event: $error'),
        ),
      );
    });
    setState(() {
      _imageFile = null;
    });
  }
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    final String fileName = DateTime.now().toString() + '.jpg';
    final imageRef = _storageReference.child('images/$fileName');
    final uploadTask = imageRef.putFile(_imageFile!);

    try {
      final snapshot = await uploadTask.whenComplete(() => null);
      _imageUrl = await snapshot.ref.getDownloadURL();
      // Save image URL to Firebase Realtime Database (modify path as needed)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image uploaded successfully!'),
        ),
      );


    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: ${e.message}'),
        ),
      );
    }
    if (_formKey.currentState!.validate()) {
      addEventToDatabase();
    }
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_imageFile != null)
                    Image.file(_imageFile!, height: 200, width: 200),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(labelText: 'Title'),
                            validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(labelText: 'Description'),
                            maxLines: null,
                            validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                          ),
                          TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(labelText: 'Image URL'),
                            validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
                          ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Deadline:",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                TextButton(
                                  onPressed: _selectDeadline,
                                  child: Text(
                                    _selectedDeadline != null
                                        ? DateFormat('yMd H:mm').format(_selectedDeadline!)
                                        : "Select Deadline",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),

                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      _imageUrl != null ? null : uploadImage();

                    },
                    child: Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _imageUrl != null ? Colors.grey : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


}
