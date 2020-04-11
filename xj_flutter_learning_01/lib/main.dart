import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

//Root
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to Fullter",
      home: RandomWords(),
      theme: ThemeData(primaryColor: Colors.brown),
    );
  }
}

//第一个页面
class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomWordsState();
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
        SavedSuggestions(savedMap: _saved)));
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: Text('Startup Name Generator'), actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],),
        body: _buildSuggestions(),);
  }

  Widget _buildRow(WordPair pair) {
    final bool saved = _saved.contains(pair);
    return ListTile(title: Text(pair.asPascalCase, style: _biggerFont),
        trailing: Icon(saved ? Icons.favorite : Icons.favorite_border,
          color: saved ? Colors.red : null,),
        onTap: () {
          setState(() {
            if (saved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }
}


//第二个页面
class SavedSuggestions extends StatelessWidget {
  final Set<WordPair> savedMap;

  SavedSuggestions({this.savedMap});

  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Add 6 lines from here...
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: _buildSavedSuggestions(context),
    );
  }

  Widget _buildSavedSuggestions(context) {
    final Iterable<ListTile> tiles = savedMap.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        }
    );

    final List<Widget> divided = ListTile.divideTiles(tiles: tiles, context: context).toList();
    return ListView(children: divided);
  }
}