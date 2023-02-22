import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Image Capture/Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();


  chooseImages() async{

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){

      setState(() {
        _image = File(image.path);
      });

    }

  }

  captureImages() async{

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if(image != null){

      setState(() {
        _image = File(image.path);
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            _image != null?Image.file(_image!):Icon(Icons.image, size: 150,),
            ElevatedButton(onPressed: (){

              chooseImages();

            },onLongPress: (){

              captureImages();

            }, child: Text("Choose / Capture")),

          ],
        ),
      ),
    );
  }
}
