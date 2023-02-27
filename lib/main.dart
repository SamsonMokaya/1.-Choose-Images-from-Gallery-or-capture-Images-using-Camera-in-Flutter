import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  late CameraController cameraController;
  File? _image;
  late ImagePicker imagePicker;
  String result = "Results will be shown here";


  @override
  void initState() {
    super.initState();

    imagePicker = ImagePicker();

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
  void dispose(){
    super.dispose();
  }


  chooseImagesFromGallery() async{

    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    _image = File(image!.path);

    if(image != null){

      setState(() {
        _image = File(image.path);
        doImageLabelling();
      });

    }

  }

  captureImagesIWithCamera() async{

    XFile? image = await imagePicker.pickImage(source: ImageSource.camera);

    _image = File(image!.path);

    if(image != null){

      setState(() {
        _image = File(image.path);
        doImageLabelling();
      });

    }

  }

  doImageLabelling() async{

    InputImage inputImage = InputImage.fromFile(_image!!);

  }





  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(


              children: <Widget>[
                SizedBox(
                  width: 100,
                ),

            Container(
              margin: EdgeInsets.only(top: 100),
              child: Stack(
                children: [
                  Image.asset("assets/frame.png",
                  height: 510,
                    width: 500,

                  ),
                  Center(
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,

                      ),
                        onPressed: (){

                      chooseImagesFromGallery();

                    },onLongPress: (){

                      captureImagesIWithCamera();

                    },
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: _image != null?Image.file(
                            _image!,
                          width: 335,
                          height: 495,
                          fit: BoxFit.fill,
                        )
                            :Container(
                          width: 340,
                          height: 330,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    result,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),








              ],
            ),
        ),
      ),
    );
  }
}
