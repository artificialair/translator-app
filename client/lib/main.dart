import 'package:flutter/material.dart';
import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import 'httphandling.dart';

// --------------------------------------------------------------------------------
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  /*http.Response http_response = ;

  Future<void> fetchUsers() async {
    final url = 'https://translator-backend-kbqg.onrender.com/test_post';
    await httphandling.FetchJSON(url);
    if (response.statusCode == 201) {
    setState(() {
        final response = jsonDecode(response_data.body) as map<String, dynamic>
      }); 
    } else {
      throw Exception('response failed');
    }
  }  */
  @override
  void initState() {
    super.initState();
    //fetchUsers();
  }  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            
          );
        },
      ),
    );
  }
}


/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

  
class _MyHomePageState extends State<MyHomePage> {
    List data = [];
    String api_endpoint = "https://translator-backend-kbqg.onrender.com/test";
    Future<void> getResponse() async {
      var response = await fetchJSON(http_endpoint);
    }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<_MyHomePageState>();
    String http_endpoint = "https://translator-backend-kbqg.onrender.com/test";

   return Scaffold(
      body: Column(
        Text("Send an HTTP Request"),
        ElevatedButton(
          onPressed: () {
            var response = await appState.getResponse(http_endpoint);
            print(response.body);
          }
        ),
      ),
    );
  }
}

*/
