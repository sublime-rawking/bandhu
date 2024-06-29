
import 'package:flutter/material.dart';

showDLoadingDialog(context){

 return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Laoding..."),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    },
  );
}