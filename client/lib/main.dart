import 'package:flutter/material.dart';
import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:record/record.dart";
import "package:provider/provider.dart";
import "package:collection/collection.dart";
import 'httphandling.dart';

// --------------------------------------------------------------------------------

Map<String, String> languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'Japanese': 'jp',
    'Latin': 'la',
    'French': 'fr',
    'German': 'de',
    'Korean': 'ko',
    'Swedish': 'sv',
    'Russian': 'ru',
    'Norwegian': 'no',
};

void main() {
    runApp(MaterialApp(home: TranslatorAppImplementation()));
}

class TranslatorApp extends StatelessWidget {
  const TranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TranslatorAppImplementation());
  }
}

class HTTPNotifier extends ChangeNotifier {
  String src_code = "";
  String dest_code = "";
  String substr = "";
  late var http_endpoint;
  final http_url = "https://translator-backend-kbqg.onrender.com";
  
  void updateURL(String str, String src, String dest) {
    http_endpoint = "${http_url}/translate?string=${str}&src=${src}&dst=${dest}";
    if (src != src_code) {
      src_code = src;
    }
    if (dest != dest_code) {
      dest_code = dest;
    }
    if (substr != str) {
      substr = str;
    }
    notifyListeners();
  }
}

class TextNotifier extends ChangeNotifier {
  String translated_text = "";
  
  void updateText(String text) {
    translated_text = text;
    notifyListeners();
  }
}

class TranslatorAppImplementation extends StatefulWidget {
  const TranslatorAppImplementation({super.key});

  @override
  State<TranslatorAppImplementation> createState() => _TranslatorAppState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _TranslatorAppState extends State<TranslatorAppImplementation> {
  bool _recording = false;
  TextEditingController _controller = TextEditingController();

  late var _http_endpoint;

  TextNotifier _textNotifier = new TextNotifier();
  HTTPNotifier _httpNotifier = new HTTPNotifier();

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    languageCodes.keys.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  String dropdownValuesrc = languageCodes.keys.first;
  String dropdownValuedest = languageCodes.keys.first;
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(150),
        alignment: FractionalOffset.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget> [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), 
                        labelText: 'Input text to be translated',), 
                      onSubmitted: (String value) async {
                        _httpNotifier.updateURL(value, _httpNotifier.src_code, _httpNotifier.dest_code);
                        print(_httpNotifier.http_endpoint);
                        var response = await http.get(Uri.parse(_httpNotifier.http_endpoint));
                        if (response.statusCode == 200) {
                          var translated_text = jsonDecode(response.body)["content"];
                          print(translated_text);
                          _textNotifier.updateText(translated_text);
                        }
                        else {
                          print("error with the http stuff, status code: ${response.statusCode}, data: ${response.body}");
                        }
                      },
                    ),
                  ),
                  Container(
                    child: ListenableBuilder(
                      listenable: _httpNotifier,
                      builder: (context, child) {
                        return DropdownMenu<String>(
                        initialSelection: languageCodes.keys.first,
                        onSelected: (String? value) {
                          setState(() {
                            dropdownValuesrc = value!;
                            });
  //void updateURL(String str, String src, String src) {
                            String localLanguageCode = languageCodes[dropdownValuesrc]!;
                            _httpNotifier.updateURL(_httpNotifier.substr, localLanguageCode, _httpNotifier.dest_code);
                            print(_httpNotifier.http_endpoint);
                          },
                        dropdownMenuEntries: menuEntries,
                        );
                      }
                    ),
                  ),
                  ],
                ),
              Column (
                children: <Widget> [
                  SizedBox(
                    width: 250,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: ListenableBuilder(
                        listenable: _textNotifier,
                        builder: (context, child) {
                          return Text("Translation: ${_textNotifier.translated_text}");
                        }
                      ),
                    )
                  ),
                  Container(
                    child: ListenableBuilder(
                      listenable: _httpNotifier,
                      builder: (context, child) {
                        return DropdownMenu<String>(
                        initialSelection: languageCodes.keys.first,
                        onSelected: (String? value) {
                          setState(() {
                            dropdownValuedest = value!;
                            });
  //void updateURL(String str, String src, String dest) {
                            String localLanguageCode = languageCodes[dropdownValuedest]!;
                            _httpNotifier.updateURL(_httpNotifier.substr, _httpNotifier.src_code, localLanguageCode);
                            print(_httpNotifier.http_endpoint);
                          },
                        dropdownMenuEntries: menuEntries,
                        );
                      }
                    ),
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }
}
/*Padding( padding: const EdgeInsets.all(8.0),
child: Icon(
Icons.mic_rounded,
color: _recording ? Colors.black: Colors.red,
size: 60,
),
),
GestureDetector(
onTap: () {
setState(() {
// Toggle light when tapped.
_recording = !_recording;
});
},
child: Container(
color: Colors.yellow.shade600,
padding: const EdgeInsets.all(8),
// Change button text when light changes state.
child: Text(_recording ? 'Begin Recording' : 'End Recording'),
),
),*/
