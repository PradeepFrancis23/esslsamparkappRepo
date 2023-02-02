

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';



class ShowImageScreeen extends StatefulWidget {



File image;
    ShowImageScreeen({ required Key key, required this.image }) : super(key: key);

  @override
  _ShowImageScreeenState createState() => _ShowImageScreeenState();
}

class _ShowImageScreeenState extends State<ShowImageScreeen> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
      imageProvider:  FileImage(widget.image),
    ),
    );
  }
}