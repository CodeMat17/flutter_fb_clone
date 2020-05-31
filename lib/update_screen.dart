import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterfbclone/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'validators.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  File _selectedImage;
  String url;
  String _myValue;
  final formKey = GlobalKey<FormState>();
  final postsReference = Firestore.instance.collection("posts");
  TextEditingController descriptionController = TextEditingController();

  bool _inProcess = false;

  void upLoadImage() async {
    if (validationAndSave()) {
      try {
        final StorageReference postImageRef =
            FirebaseStorage.instance.ref().child('Post Images');
        var timeKey = DateTime.now();
        final StorageUploadTask uploadTask = postImageRef
            .child(timeKey.toString() + ".jpg")
            .putFile(_selectedImage);
        var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        url = imageUrl.toString();
        print('Image Url: $url');

        goToHomePage();
        saveToDatabase(url);
      } on PlatformException catch (e) {
        throw Exception(e.toString());
      }
    }
  }

  void saveToDatabase(url) {
    var currentTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(currentTimeKey);
    String time = formatTime.format(currentTimeKey);
    String id =
        Firestore.instance.collection('posts').document().documentID.toString();

    try {
      postsReference.document(id).setData({
        "image": url,
        "avatar": url,
        "post": _myValue,
        "date": date,
        "time": time,
        "name": 'codeMat Matthew',
        "likes": {},
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  goToHomePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  getCameraImage() async {
    this.setState(() {
      _inProcess = true;
    });
    Navigator.pop(context);

    File image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      image = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: 'RPS Cropper',
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ));
      this.setState(() {
        this._selectedImage = image;
        _inProcess = false;
      });
    } else {
      Container();
    }
  }

  getGalleryImage() async {
    this.setState(() {
      _inProcess = true;
    });
    Navigator.pop(context);
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      image = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: 'RPS Cropper',
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ));
      this.setState(() {
        this._selectedImage = image;
        _inProcess = false;
      });
    } else {
      //Container();
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  bool validationAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Capture Image',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SimpleDialogOption(
                          child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: getCameraImage,
                            child: FaIcon(
                              FontAwesomeIcons.camera,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                    ),
                    Expanded(
                      child: SimpleDialogOption(
                          child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: getGalleryImage,
                            child: FaIcon(
                              FontAwesomeIcons.solidAddressBook,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 40.0),
                SimpleDialogOption(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          'Facebook',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.paperPlane,
                color: _selectedImage == null ? Colors.grey : Colors.blue,
                size: 30.0,
              ),
              onPressed: _selectedImage != null ? upLoadImage : null,
              //validationAndSave
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.asset(
                                  'assets/images/encrypt.webp',
                                  fit: BoxFit.cover,
                                  height: 100.0,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: TextFormField(
                                controller: descriptionController,
                                maxLines: 5,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  hintText: 'Write something',
                                ),
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Description is required.'
                                      : null;
                                },
                                onSaved: (value) {
                                  _myValue = value;
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.cameraRetro,
                                  size: 35.0,
                                ),
                                onPressed: () => takeImage(context),
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: 15),
                        Container(
                          child: _selectedImage == null
                              ? Container()
                              : Container(
                                  child: Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width / 2,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(_selectedImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        (_selectedImage == null)
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.deepOrange,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedImage = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            (_inProcess)
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Center()
          ],
        ),
      ),
    );
  }
}
