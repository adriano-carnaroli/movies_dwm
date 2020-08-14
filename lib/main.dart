import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/filme.dart';
import './views/movie_row.dart';

void main() => runApp(MyMoviesStatefulBody());

class MyMoviesStatefulBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyMoviesState();
  }
}

class MyMoviesState extends State<StatefulWidget> {
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  final filmes = List<Filme>();

  _fetchData() async {
    filmes.clear();
    final uriString =
        'http://my-json-server.typicode.com/adriano-carnaroli/apiMovies/filmes';

    final response = await http.get(uriString);
    if (response.statusCode == 200) {
      final coursesJson = json.decode(response.body);
      coursesJson.forEach((filmeDict) {
        final filme = Filme(
            filmeDict["id"],
            filmeDict["titulo"],
            filmeDict["ano"],
            filmeDict["genero"],
            "",
            "",
            "",
            filmeDict["fundo"],
            "");
        filmes.add(filme);
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movies",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Filmes Populares"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _fetchData();
                  });
                },
              )
            ],
          ),
          body: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: filmes.length,
                      itemBuilder: (context, i) {
                        final filme = filmes[i];
                        return FlatButton(
                          padding: EdgeInsets.all(0.0),
                          child: MovieRow(filme),
                          onPressed: () {
                            print("Pressed $i");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MovieDetailsPage(filme)));
                          },
                        );
                      },
                    ))),
    );
  }
}

class MovieDetailsPage extends StatefulWidget {
  final Filme filme;
  MovieDetailsPage(this.filme);
  @override
  State<StatefulWidget> createState() {
    return MovieDetailsState(filme);
  }
}

class MovieDetailsState extends State<MovieDetailsPage> {
  final Filme filme;
  MovieDetailsState(this.filme);
  Filme filmeDetalhe = Filme(0, "", "", "", "", "", "", "", "");

  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  _fetchLessons() async {
    final urlString =
        'http://my-json-server.typicode.com/adriano-carnaroli/apiMovies/filmes/' +
            filme.id.toString();
    print("Fetching: " + urlString);
    final response = await http.get(urlString);
    final filmeDict = json.decode(response.body);
    this.filmeDetalhe = Filme(
        filmeDict["id"],
        filmeDict["titulo"],
        filmeDict["ano"],
        filmeDict["genero"],
        filmeDict["titulo_original"],
        filmeDict["idioma_original"],
        filmeDict["capa"],
        filmeDict["fundo"],
        filmeDict["sinopse"]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filmeDetalhe.titulo),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        filmeDetalhe.capa,
                        width: 150.0,
                      ),
                      Container(
                        width: 12.0,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Título: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              filmeDetalhe.titulo,
                            ),
                            Container(
                              height: 4.0,
                            ),
                            Text(
                              "Ano de Lançamento: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(filmeDetalhe.ano),
                            Container(
                              height: 4.0,
                            ),
                            Text(
                              "Gênero:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(filmeDetalhe.genero),
                            Container(
                              height: 4.0,
                            ),
                            Text(
                              "Idioma Original:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(filmeDetalhe.idioma_original),
                            Container(
                              height: 4.0,
                            ),
                            Text(
                              "Título Original:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(filmeDetalhe.titulo_original),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Sinopse:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 6.0,
                        ),
                        Text(filmeDetalhe.sinopse),
                      ],
                    ),
                  ),
                ),
              ]),
      ),
    );
  }
}
