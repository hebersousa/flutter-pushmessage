import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pushnotificationexample/models/mensagem.dart';
import 'dart:math';

class ChatScreen extends StatefulWidget {
  String apelido;
  ChatScreen( {Key key,@required this.apelido} ):super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  List<Color> cores = [Colors.blue, Colors.green, Colors.red, Colors.brown, Colors.teal, Colors.pink, Colors.orange];
   Map<String,Color> _corUsuario = {};
  List<Mensagem> _mensagens =[];

   final TextEditingController textcontroller = new TextEditingController();
   final ScrollController scrollController = new ScrollController();


  @override
  void initState(){
    super.initState();

    firebaseMessaging.configure(
        onMessage: (Map<String,dynamic> message) async{

            setState(() {
              Mensagem msg = Mensagem.fromJSON(message);

              if( !_corUsuario.containsKey(msg.apelido)) {
                  Random rand = new Random();
                  _corUsuario[msg.apelido] = cores[rand.nextInt(cores.length - 1)];
              }
              _mensagens.add( msg);
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
            });

          print(message);
        }
    );
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.subscribeToTopic('curso');

    firebaseMessaging.getToken().then((token)=>print(token));

    post('{ "tipo":"entrada","apelido":"${widget.apelido}"}');
  }



  Future<dynamic> post(String data) async{
    final url = 'http://192.168.0.29:8081/send';
    return http.post(
        url,
        headers: {'Content-Type':'application/json'},
        body: data
    )
        .then((http.Response resposta){

      var res = resposta;
    } );
  }

  @override
  Widget build(BuildContext context) {

    var backButton = new IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
      post('{"tipo":"saida","apelido":"${widget.apelido}"}');
      firebaseMessaging.unsubscribeFromTopic('curso');
      Navigator.of(context).pop();

    });
    var appBar = AppBar(title: Text('Chat Flutter'),leading: backButton,);

    var inputField = Container( color: Colors.grey[100],
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                  controller: textcontroller,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Envie uma mensagem'
                  ))),
          new InkWell(
            child: Icon(Icons.send),
            onTap: (){
              if(textcontroller.text.isNotEmpty)
                post('{"tipo":"mensagem","apelido":"${widget.apelido}","texto":"${textcontroller.text}"}');
              textcontroller.text ="";
              },
          )
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: new Column(
        children:[ Flexible( child: getMessages(),),
        Divider(height: 1.0,),
        inputField
        ]
      ),
    );
  }

  Widget getMessages(){
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 25.0),
        controller: scrollController,
        itemCount:_mensagens.length,
        itemBuilder: (context, i) => Padding(
              child: buildItem(_mensagens[i]),
              padding: const EdgeInsets.only(top: 5.0),)

    );
  }
  Widget buildItem(Mensagem msg){

    TextStyle style = TextStyle(color: _corUsuario[msg.apelido]);
    var texto = '';
    if(msg.tipo == 'entrada')
        texto = "${msg.apelido} entrou ...";
    else if(msg.tipo == 'saida')
        texto = "${msg.apelido} saiu ...";
    else
        texto = "${msg.apelido}: ${msg.texto}";

    return Text(texto,style: style,);
  }
}
