import 'package:flutter/material.dart';
class LoadingDialog extends StatelessWidget {
  String messageText;
  LoadingDialog({super.key,required this.messageText,});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(9),
          child: Row(
            children: [
              const SizedBox(width: 5,),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(width: 5,),
              Text(
                messageText,
                style: const TextStyle(
                    color: Colors.white
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
