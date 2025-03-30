import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData.dark(),
      home: CharacterList(),
    );
  }
}

class CharacterList extends StatefulWidget {
  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  int page = 1;
  List characters = [];
  bool isLoading = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character?page=$page'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        characters = data['results'];
        currentIndex = 0;
        isLoading = false;
      });
    }
  }

  void nextCharacter() {
    if (currentIndex < characters.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      nextPage();
    }
  }

  void prevCharacter() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    } else if (page > 1) {
      prevPage();
    }
  }

  void nextPage() {
    setState(() {
      page++;
    });
    fetchCharacters();
  }

  void prevPage() {
    if (page > 1) {
      setState(() {
        page--;
      });
      fetchCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rick and Morty Characters')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.teal,
                        child: Column(
                          children: [
                            Image.network(
                              characters[currentIndex]['image'],
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                characters[currentIndex]['name'],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: prevCharacter,
                                    child: Text('Anterior'),
                                  ),
                                  ElevatedButton(
                                    onPressed: nextCharacter,
                                    child: Text('Siguiente'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
