
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PantheonApp());
}

class PantheonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantheon',
      theme: ThemeData.dark(),
      home: PantheonHome(),
    );
  }
}

class PantheonHome extends StatefulWidget {
  @override
  _PantheonHomeState createState() => _PantheonHomeState();
}

class _PantheonHomeState extends State<PantheonHome> {
  final TextEditingController _controller = TextEditingController();
  String _response = "";

  Future<void> _askAI() async {
    final question = _controller.text;
    final apiKey = ""; // Insert your OpenAI API key here

    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": question}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _response = data["choices"][0]["message"]["content"];
      });
    } else {
      setState(() {
        _response = "Error: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pantheon AI")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Ask a question"),
            ),
            ElevatedButton(
              onPressed: _askAI,
              child: Text("Ask"),
            ),
            SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(_response))),
          ],
        ),
      ),
    );
  }
}
