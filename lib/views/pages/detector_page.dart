import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetectorPage extends StatefulWidget {
  const DetectorPage({Key? key}) : super(key: key);

  @override
  State<DetectorPage> createState() => _DetectorPageState();
}

class _DetectorPageState extends State<DetectorPage> {
  File? _image;
  List? _output;
  String _result = "No Tumor";
  bool _loading = false;

  final picker = ImagePicker();

  Future loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: 'assets/labels.txt',
    );
  }

  @override
  void initState() {
    super.initState();

    loadModel().then(
      (value) => {
        setState(() {}),
      },
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      setState(() {
        _image = File(image.path);

        _output = null;
        _loading = true;
      });

      await Future.delayed(const Duration(milliseconds: 200));

      detectImage(_image!);
      _loading = false;
    } on PlatformException {
      //
    }
  }

  Future detectImage(File image) async {
    final output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output!;
      try {
        if (_output != null) {
          if (_output![0]["label"] == "glioma_tumor") {
            _result = "Glioma Tumor";
          } else if (_output![0]["label"] == "meningioma_tumor") {
            _result = "Meningioma Tumor";
          } else if (_output![0]["label"] == "pituitary_tumor") {
            _result = "Pituitary Tumor";
          } else if (_output![0]["label"] == "no_tumor") {
            _result = "No Tumor Detected";
          }
        }
      } catch (e) {
        _result = "Cannot Detect Tumor, Please try with a different image";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Tumor Detector",
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto",
                ),
              ),
              GestureDetector(
                onTap: bottomModal,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green[100],
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(2, 5),
                        )
                      ],
                    ),
                    child: _image == null
                        ? Icon(
                            Icons.image_outlined,
                            size: 200,
                            color: Colors.green[300],
                          )
                        : Image.file(
                            _image!,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_loading) const CircularProgressIndicator(),
              if (_output != null)
                Text(
                  _result,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 32,
                  ),
                ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonBuilder(
                    'Pick From Camera',
                    Icons.camera,
                    () => pickImage(ImageSource.camera),
                  ),
                  buttonBuilder(
                    'Pick From Gallery',
                    Icons.photo_library,
                    () => pickImage(ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonBuilder(String text, IconData icon, onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  Future bottomModal() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {
          Navigator.pop(context);
        },
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Select Image From",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    modalButtonBuilder(
                      'Pick From Camera',
                      Icons.camera,
                      () {
                        Navigator.pop(context);
                        pickImage(ImageSource.camera);
                      },
                    ),
                    modalButtonBuilder(
                      'Pick From Gallery',
                      Icons.photo_library,
                      () {
                        Navigator.pop(context);
                        pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget modalButtonBuilder(String text, IconData icon, onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon),
          const SizedBox(width: 15),
          Text(text),
        ],
      ),
    );
  }
}
