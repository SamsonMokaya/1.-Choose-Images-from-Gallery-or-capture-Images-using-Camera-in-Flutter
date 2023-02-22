import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Image Capture/Picker & Live Video Feed'),
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

  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[

            //image preview
            _image != null?Image.file(_image!):Icon(Icons.image, size: 150,),
            ElevatedButton(onPressed: (){

              chooseImages();

            },onLongPress: (){

              captureImages();

            }, child: Text("Choose / Capture")),

            CameraPreview(cameraController),

          ],
        ),
      ),
    );
  }
}
