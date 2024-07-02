
import 'package:flutter/material.dart';

showDLoadingDialog(context){

 return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Loading..."),
              SizedBox(height: 20,),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      );
    },
  );
}