import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this._sendMessager);

  final Function({String text, File imgFile}) _sendMessager;

  @override
  _TextComposerState createState() => _TextComposerState();
}


class _TextComposerState extends State<TextComposer> {

  final TextEditingController _controller = TextEditingController();
  bool _isComposing = false;

  void _reset(){
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () async {
              final picker = ImagePicker();
              //final pickedFile = await picker.getImage(source: ImageSource.camera);
              final PickedFile imgFile = await picker.getImage(source: ImageSource.camera);
              if(imgFile == null){return;}
              widget._sendMessager(imgFile: File(imgFile.path));
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: ("Enviar uma Mensagem")),
              onChanged: (text){
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text){
                widget._sendMessager(text: text);
                _reset();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? (){
              widget._sendMessager(text: _controller.text);
              _reset();
            } : null,
          )
        ],
      ),
    );
  }
}
