import 'package:flutter/material.dart';
import 'package:pushnotificationexample/screens/chat_sc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class HomeScreen  extends StatefulWidget {
  @override
  _StateHomeScreen createState() => _StateHomeScreen();
}

class _StateHomeScreen extends State<HomeScreen> {



  @override
  void initState(){
    super.initState();

  }


  String _apelido = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    var titleStyle = TextStyle(
        fontSize: 42.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic);

    var titleApp = new Padding(
         padding: const EdgeInsets.symmetric(vertical: 100.0),
        child: Text('Flutter Chat',softWrap: false, style: titleStyle),
    );


    var button = new Padding(
      padding: const EdgeInsets.all(25.0),
      child: RaisedButton(
        child: Text('Entrar', style: TextStyle(color: Colors.white),),
        color: Theme.of(context).accentColor,
        onPressed: (){
          if(_apelido.isEmpty) {
              final snackBar = SnackBar(content: Text('Digite um apelido'),);
              scaffoldKey.currentState.showSnackBar(snackBar);
          }else{
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => new ChatScreen(apelido: _apelido,)));
          }
        },
      ),
    );

     var field = TextField(

        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, color: Colors.black),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Entre com um apelido ...'
        ),
       onChanged: (text){
         setState(() {
           _apelido = text;
         });
       },

     );

    var containerField = new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:  BorderRadius.circular(8.0)),
          child: field
      ));

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
        body: new SingleChildScrollView(

            child: Column(
                  children:[
                    titleApp,
                    containerField,
                    button
                  ]
          ),

        )

    );
  }
}
