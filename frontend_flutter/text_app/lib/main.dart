import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// CHANGE 1: Imported the official markdown library
import 'package:flutter_markdown/flutter_markdown.dart';

void main() => runApp(
  MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, fontFamily: 'Figtree'),
  ),
);

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _queryController = TextEditingController();
  String _aiOutput = "AI output will stream here...";
  bool _isLoading = false;

  Future<void> connectToPython(String userQuery) async {
    if (userQuery.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiOutput = "";
    });

    final url = Uri.parse('http://127.0.0.1:5000/api/query/');
    final client = http.Client();

    try {
      final request = http.StreamedRequest('POST', url);
      request.headers['Content-Type'] = 'application/json';

      request.sink.add(utf8.encode(jsonEncode({'query': userQuery})));
      request.sink.close();

      final response = await request.send();

      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (String line) {
              if (line.startsWith('data: ')) {
                String token = line.substring(6);

                setState(() {
                  // CHANGE 2: Rehydrate custom [NEWLINE] markers back into native \n strings
                  // before appending them into the dynamic rendering stream.
                  String cleanToken = token.replaceAll('[NEWLINE]', '\n');
                  _aiOutput += cleanToken;
                });
              }
            },
            onDone: () {
              setState(() {
                _isLoading = false;
              });
              client.close();
            },
          );
    } catch (e) {
      setState(() {
        _aiOutput = "Connection failed: $e";
        _isLoading = false;
      });
      client.close();
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RAG Pipeline - AI Assistant',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _queryController,
                    cursorColor: Colors.blue,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      hintText: 'Enter your query here....',
                      hintStyle: TextStyle(
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      focusColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => connectToPython(_queryController.text),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    iconSize: 27.0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.search, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  border: Border.all(color: Colors.grey[900]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topLeft,
                    // CHANGE 3: Replaced the standard Text widget with MarkdownBody
                    // to interpret styling layers dynamically.
                    child: MarkdownBody(
                      data: _aiOutput.isEmpty
                          ? "AI output will stream here..."
                          : _aiOutput,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          height: 1.5,
                        ),
                        h1: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        h2: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        strong: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        listBullet: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
