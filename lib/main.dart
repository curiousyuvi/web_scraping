import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = 'Result comes here';
  bool isLoading = false;

  Future<String> extractData() async {
    final response = await http.Client()
        .get(Uri.parse('https://www.goodreads.com/quotes/tag/web-development'));
    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      try {
        var responseString = document.getElementsByClassName('quoteText')[0];

        print(responseString.text.trim());
        return responseString.text.trim();
      } catch (e) {
        return 'ERROR!';
      }
    } else {
      return 'ERROR: ${response.statusCode}.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeeksForGeeks',
      theme: ThemeData(
        accentColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('GeeksForGeeks')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? CircularProgressIndicator()
                  : Text(result,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 50),
              MaterialButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final response = await extractData();
                  setState(() {
                    result = response;
                    isLoading = false;
                  });
                },
                child: Text(
                  'Scrap Data',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              )
            ],
          )),
        ),
      ),
    );
  }
}
