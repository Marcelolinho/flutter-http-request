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

  void apiErrorDialog(String e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: BoxConstraints(maxHeight: 500),
              padding: EdgeInsets.all(20),
              color: Colors.red[50],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Seguinte erro retornado:',
                    style: TextStyle(color: Colors.red[800], fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(e, style: TextStyle(color: Colors.red[900]),),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o popup
                      },
                      child: Text('Voltar', style: TextStyle(color: Colors.red[800]),),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
  }

  void apiOkDialog(Map user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(maxHeight: 500),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user['avatar']),
                ),
                SizedBox(height: 16),
                Text('Nome: ${user['first_name']}'),
                Text('Email: ${user['email']}'),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o popup
                    },
                    child: Text('Fechar'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void userGetter(String user) async {
    try {
      final response = await http.get(Uri.parse("https://reqres.in/api/users/$user"));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        if (decodedResponse.containsKey('data')) {
          apiOkDialog(decodedResponse['data']);
        } else {
          apiErrorDialog("Resposta inesperada da API.");
        }
      } else if (response.statusCode == 404) {
        apiErrorDialog("Usuário não encontrado Jovem!");
      } else {
        apiErrorDialog("Erro ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (e) {
      if (mounted) {
        apiErrorDialog("Erro inesperado: $e");
      }
    }
  }

  void handleUserClick(TextEditingController input) {
    int? userIdParsed = int.tryParse(input.text);
    if (userIdParsed == null) {
      apiErrorDialog("Por favor digite números!");
    } else {
      userGetter(input.text);
    }
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
                Text("Encontre o Usuário", style: Theme.of(context).textTheme.headlineMedium),
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
                ElevatedButton(
                    onPressed: () => handleUserClick(userId),
                    child: Text("Buscar"))
              ],
            )
          ],
        ),

      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
