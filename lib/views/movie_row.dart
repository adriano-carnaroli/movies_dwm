import 'package:flutter/material.dart';
import '../models/filme.dart';

class MovieRow extends StatelessWidget {
  final Filme filme;
  MovieRow(this.filme);
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
               Image.network(filme.fundo),
              new Container(
                height: 12.0,
              ),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 16.0,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          filme.titulo,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 4.0,
                        ),
                        Text(
                          filme.ano + " * " + filme.genero,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}
