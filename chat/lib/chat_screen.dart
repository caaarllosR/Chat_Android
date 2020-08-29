import 'dart:io';

import 'package:chat/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat/text_composer.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User _currentUser;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user){
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User> _getUser() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = userCredential.user;
      return user;
    } catch (error) {
      return null;
    }
  }

  void _sendMessage({String text, File imgFile}) async {

    final User user = await _getUser();

    if(user==null){
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Não foi possível fazer o login. Teste novamente!"),
            backgroundColor: Colors.red,
          )
      );
    }
    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
      "time": Timestamp.now()
    };

    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(user.uid+DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      data["imgUrl"] = url;
    }

    setState(() {
      _isLoading = false;
    });

    if(text != null) data['text'] = text;
    FirebaseFirestore.instance.collection("messages").add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            _currentUser != null ? 'Olá, ${_currentUser.displayName}' : 'Chat App.'
          ),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            _currentUser != null ? IconButton(
              icon:  Icon(Icons.exit_to_app),
              onPressed:  (){
                FirebaseAuth.instance.signOut();
                googleSignIn.signIn();
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Você saiu com sucesso."),
                  )
                );
              },
            ) : Container()
          ],
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('messages').orderBy("time").snapshots(),
                    builder: (context, snapshot){
                      switch(snapshot.connectionState){
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          List<DocumentSnapshot> documents = snapshot.hasData ? snapshot.data.docs.reversed.toList() : new List<DocumentSnapshot>();

                          return ListView.builder(
                              itemCount: documents.length,
                              reverse: true,
                              itemBuilder: (context, index){
                                return ChatMessage(
                                    documents[index].data(),
                                    documents[index].data()['uid'] == _currentUser?.uid
                                );
                              }
                          );
                      }
                    },
                  ),
              ),
              _isLoading ? LinearProgressIndicator() : Container(),
              TextComposer(_sendMessage),
          ]
        )
    );
  }
}
