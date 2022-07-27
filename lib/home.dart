import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  static const Color primarycolor = Color(0xFF7DCD85);
  CroppedFile? image;
  CroppedFile? croppedFile;
  void showoptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Select source',
              style: TextStyle(
                color: primarycolor,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: getFromGallery,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(111, 194, 225, 194),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.photo_library,
                              size: 26,
                              color: primarycolor,
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 16,
                                color: primarycolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: getFromCamera,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(111, 194, 225, 194),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.camera,
                              size: 26,
                              color: primarycolor,
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Camera',
                              style: TextStyle(
                                fontSize: 16,
                                color: primarycolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            backgroundColor: Colors.white,
            toolbarTitle: 'Cropper',
            toolbarColor: primarycolor,
            statusBarColor: primarycolor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: primarycolor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    setState(() {
      image = croppedFile;
    });
  }

  void saveImage() async {
    GallerySaver.saveImage(image!.path).then((bool? success) {
      setState(() {
        Fluttertoast.showToast(
            msg: "Image saved to gallery",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFF778472),
            textColor: Colors.white,
            fontSize: 16.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Croppie'),
        centerTitle: true,
        backgroundColor: primarycolor,
      ),
      body: image == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Select an image to crop',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: showoptions,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(111, 194, 225, 194),
                        border: Border.all(
                          color: primarycolor,
                          width: 10,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate,
                        size: 100,
                        color: primarycolor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Your image has been cropped!",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Image.asset("assets/happyCroppie.png"),
                    Container(
                      decoration: BoxDecoration(
                        color: primarycolor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(File(image!.path)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Editor(),
                                ));
                          },
                          elevation: 2.0,
                          fillColor: primarycolor,
                          padding: const EdgeInsets.all(15.0),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.exit_to_app,
                            size: 35.0,
                            color: Colors.white,
                          ),
                        ),
                        RawMaterialButton(
                          onPressed: () async {
                            await Share.shareFiles(
                              [image!.path],
                            );
                          },
                          elevation: 2.0,
                          fillColor: primarycolor,
                          padding: const EdgeInsets.all(15.0),
                          shape: const CircleBorder(),
                          child: const Icon(Icons.share,
                              size: 35.0, color: Colors.white),
                        ),
                        RawMaterialButton(
                          onPressed: () {
                            saveImage();
                          },
                          elevation: 2.0,
                          fillColor: primarycolor,
                          padding: const EdgeInsets.all(15.0),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.save,
                            size: 35.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
