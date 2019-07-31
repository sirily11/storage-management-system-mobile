import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';
import 'package:mobile/ItemImage/ItemImageUploadScreen.dart';
import 'package:mobile/States/CameraState.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ItemImageScreen extends StatefulWidget {
  final int itemId;
  final String itemName;
  ItemImageScreen(this.itemId, this.itemName);

  @override
  State<StatefulWidget> createState() {
    return ItemImageScreenState(this.itemId, this.itemName);
  }
}

class ItemImageScreenState extends State<ItemImageScreen> {
  CameraController _controller;
  CameraDescription _camera;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final int itemId;
  final String itemName;

  ItemImageScreenState(this.itemId, this.itemName);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future init() async {
    final cameras = await availableCameras();
    this._camera = cameras[0];
    this._controller = CameraController(_camera, ResolutionPreset.high);
    await _controller.initialize();
    setState(() {});
  }

  Future takePhoto() async {
    var imageState = Provider.of<CameraState>(context);
    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.jpg',
    );
    await _controller.takePicture(path);
    imageState.addItem(path);

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Image has been taken"),
      duration: Duration(seconds: 1),
    ));
  }

  onClear(context) async {
    var imageState = Provider.of<CameraState>(context);
    await imageState.clear();
    // Navigator.of(context).pop();
  }

  Widget cameraPreview() {
    return Stack(children: <Widget>[
      CameraPreview(this._controller),
      ImageCard(),
      FormButtons(this.takePhoto)
    ]);
  }

  navToUploadScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ItemImageUploadScreen(this.itemId, this.itemName);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var imageState = Provider.of<CameraState>(context);
    Widget body;
    if (_controller == null) {
      body = Container();
    } else {
      body = AspectRatio(
        child: cameraPreview(),
        aspectRatio: _controller.value.aspectRatio,
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("Add Item Image"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await imageState.clear();
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed:
                imageState.imagePath.length == 0 ? null : navToUploadScreen,
            icon: Icon(Icons.done),
          )
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        heroTag: "Clear photo",
        child: Icon(Icons.clear),
        onPressed: () => onClear(context),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final double _mb = 140;
  final double _height = 100;

  Widget _ImageCard(Function remove, String imagePath) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(imagePath),
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 3,
          height: 40,
          child: IconButton(
            onPressed: () async {
              await remove(imagePath);
            },
            icon: CircleAvatar(
              child: Icon(
                Icons.clear,
                size: 20,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var imageState = Provider.of<CameraState>(context);
    return Positioned(
      bottom: _mb,
      height: _height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: AnimatedList(
            scrollDirection: Axis.horizontal,
            key: imageState.listKey,
            initialItemCount: imageState.imagePath.length,
            itemBuilder: (context, index, animation) {
              return ScaleTransition(
                  scale: animation,
                  child: _ImageCard((String path) async {
                    var index = await imageState.removeImage(path);
                    imageState.listKey.currentState.removeItem(index,
                        (context, animation) {
                      return ScaleTransition(
                          scale: animation, child: _ImageCard(null, path));
                    });
                  }, imageState.imagePath[index]));
            }),
      ),
    );
  }
}

class FormButtons extends StatelessWidget {
  final double _mb = 60;
  final double _height = 100;
  final Function takePhoto;

  FormButtons(this.takePhoto);

  onClear(context) async {
    var imageState = Provider.of<CameraState>(context);
    await imageState.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      bottom: _mb,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 70,
                height: 70,
                child: RawMaterialButton(
                  child: Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  ),
                  shape: new CircleBorder(),
                  fillColor: Colors.blue,
                  onPressed: takePhoto,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
