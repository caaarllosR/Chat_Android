import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: "Nome Completo"),
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                if (text.isEmpty)
                  return "Nome inválido";
                else
                  return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(hintText: "E-mail"),
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                if (text.isEmpty || !text.contains("@"))
                  return "E-mail inválido";
                else
                  return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(hintText: "Senha"),
              obscureText: true,
              validator: (text) {
                if (text.isEmpty || text.length < 6)
                  return "Senha inválida";
                else
                  return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(hintText: "Endereço"),
              validator: (text) {
                if (text.isEmpty || text.length < 6)
                  return "Endereço inválida";
                else
                  return null;
              },
            ),
            SizedBox(height: 16.0),
            SizedBox(
                height: 44.0,
                child: RaisedButton(
                  child: Text(
                    "Criar Conta",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}
                  },
                )),
          ],
        ),
      ),
    );
  }
}
