import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Colors.green,
      scaffoldBackgroundColor: Colors.green[100],
      primaryColor: Colors.green,
    ),
    home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result1 = 'Result 1';
  String result2 = 'Result 2';
  String result3 = 'Result 3';
  bool isLoading = false;

  Future<List<String>> extractData() async {
    final response =
        await http.Client().get(Uri.parse('https://www.geeksforgeeks.org/'));
    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      try {
        var responseString1 = document
            .getElementsByClassName('articles-list')[0]
            .children[0]
            .children[0]
            .children[0];

        print(responseString1.text.trim());

        var responseString2 = document
            .getElementsByClassName('articles-list')[0]
            .children[1]
            .children[0]
            .children[0];

        print(responseString2.text.trim());

        var responseString3 = document
            .getElementsByClassName('articles-list')[0]
            .children[2]
            .children[0]
            .children[0];

        print(responseString3.text.trim());

        return [
          responseString1.text.trim(),
          responseString2.text.trim(),
          responseString3.text.trim()
        ];
      } catch (e) {
        return ['', '', 'ERROR!'];
      }
    } else {
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GeeksForGeeks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Text(result1,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(result2,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Text(result3,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            MaterialButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final response = await extractData();
                setState(() {
                  result1 = response[0];
                  result2 = response[1];
                  result3 = response[2];
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
    );
  }
}
