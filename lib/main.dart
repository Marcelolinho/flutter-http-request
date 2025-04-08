import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'User Finder (By Id)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController userId = new TextEditingController();

  void userGetter(String user) {
    var url = Uri.parse("https://reqres.in/api/users/$user");
    var response = http.get(url)
     .then(
        (response) {
          return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        }
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Teste", style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child:
                    TextField(
                      controller: userId,
                      decoration: InputDecoration(
                          labelText: "Escolha entre 1 a 12",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12)
                          )
                      ),
                    )
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: , child: child)
              ],
            )
          ],
        ),

      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
