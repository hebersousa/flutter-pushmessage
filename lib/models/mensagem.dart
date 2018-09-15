import 'package:flutter/material.dart';

class Mensagem {

  final String apelido;
  final String tipo;
  String texto;

  Mensagem.fromJSON(Map json)
      : tipo=json['tipo'],
        apelido= json['apelido'],
        texto = json['texto'];
}