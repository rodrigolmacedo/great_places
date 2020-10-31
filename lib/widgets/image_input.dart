import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput({Key key, @required this.onSelectImage}) : super(key: key);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storagedImage;

  Future<void> _takePicture() async {
    final _picker = ImagePicker();
    PickedFile _imageFile =
        await _picker.getImage(source: ImageSource.camera, maxWidth: 600);

    if (_imageFile == null) return;

    setState(() {
      _storagedImage = File(_imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storagedImage.path);

    final savedImage = await _storagedImage.copy(
      '${appDir.path}/$fileName',
    );

    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 180,
          height: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          child: _storagedImage == null
              ? Text('Nenhuma imagem')
              : Image.file(
                  File(_storagedImage.path),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.camera),
            label: Text('Tirar Foto'),
            textColor: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
