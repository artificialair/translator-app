import 'package:flutter/material.dart';
import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:record/record.dart";
import "package:provider/provider.dart";
import "package:collection/collection.dart";

import 'httphandling.dart';
import 'recordFramework.dart';

// --------------------------------------------------------------------------------

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

class tLCD {
  static Map<String, String> languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'Japanese': 'ja',
    'Latin': 'la',
    'French': 'fr',
    'German': 'de',
    'Korean': 'ko',
    'Swedish': 'sv',
    'Russian': 'ru',
    'Norwegian': 'no',
    'Arabic': "ar",
  };
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    languageCodes.keys.map<MenuEntry>(
      (String name) => MenuEntry(value: name, label: name),
    ),
  );

  static String dropdownValuesrc = languageCodes.keys.first;
  static String dropdownValuedest = languageCodes.keys.first;
}

class HTTPNotifier extends ChangeNotifier {
  String src_code = "en";
  String dest_code = "en";
  String substr = "";
  late var http_endpoint;
  final http_url = "https://translator-backend-kbqg.onrender.com";

  void updateURL(String str, String src, String dest) {
    http_endpoint =
        "${http_url}/translate?string=${str}&src=${src}&dest=${dest}";
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
  var recorder = recordFramework();

  TextNotifier _textNotifier = new TextNotifier();
  HTTPNotifier _httpNotifier = new HTTPNotifier();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        alignment: FractionalOffset.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.1,
                horizontal: size.width * 0.1,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: SizedBox(
                      width: size.width * 0.2,
                      height: size.height * 0.4,
                      child: TextField(
                        controller: _controller,
                        minLines: 25,
                        maxLines: 25,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Input text to be translated',
                        ),
                        onSubmitted: (String value) async {
                          _httpNotifier.updateURL(
                            value,
                            _httpNotifier.src_code,
                            _httpNotifier.dest_code,
                          );
                          print(_httpNotifier.http_endpoint);
                          var response = await http.get(
                            Uri.parse(_httpNotifier.http_endpoint),
                          );
                          if (response.statusCode == 200) {
                            var translated_text =
                                jsonDecode(response.body)["content"];
                            print(translated_text);
                            _textNotifier.updateText(translated_text);
                          } else {
                            print(
                              "error with the http stuff, status code: ${response.statusCode}, data: ${response.body}",
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  ListenableBuilder(
                    listenable: _httpNotifier,
                    builder: (context, child) {
                      return LanguageDropdown(
                        notifier: _httpNotifier,
                        identifier: 1,
                      );
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String text = _controller.text;
                    _httpNotifier.updateURL(
                      text,
                      _httpNotifier.src_code,
                      _httpNotifier.dest_code,
                    );
                    var response = await http.get(
                      Uri.parse(_httpNotifier.http_endpoint),
                    );
                    if (response.statusCode == 200) {
                      var translatedText = jsonDecode(response.body)["content"];
                      _textNotifier.updateText(translatedText);
                    } else {
                      _textNotifier.updateText(
                        "HTTP Error, please try again later.",
                      );
                    }
                  },
                  child: Text('Translate!'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.mic_rounded,
                    color: _recording ? Colors.black : Colors.red,
                    size: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle light when tapped.
                      _recording = !_recording;
                      recorder.toggleRecording();
                    });
                  },
                  child: Container(
                    color: Colors.yellow.shade600,
                    padding: const EdgeInsets.all(8),
                    // Change button text when light changes state.
                    child: Text(
                      _recording ? 'Begin Recording' : 'End Recording',
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.1,
                horizontal: size.width * 0.1,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: SizedBox(
                      width: size.width * 0.15,
                      height: size.height * 0.4,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: ListenableBuilder(
                          listenable: _textNotifier,
                          builder: (context, child) {
                            return Text(
                              "Translation: ${_textNotifier.translated_text}",
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  ListenableBuilder(
                    listenable: _httpNotifier,
                    builder: (context, child) {
                      return LanguageDropdown(
                        notifier: _httpNotifier,
                        identifier: 2,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageDropdown extends StatefulWidget {
  HTTPNotifier notifier;
  int identifier;

  LanguageDropdown({Key? key, required this.notifier, required this.identifier})
    : super(key: key);

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, child) {
        return DropdownMenu<String>(
          initialSelection: tLCD.languageCodes.keys.first,
          onSelected: (String? value) {
            setState(() {
              (widget.identifier == 1)
                  ? tLCD.dropdownValuesrc = value!
                  : tLCD.dropdownValuedest = value!;
            });
            String localLanguageCodedest =
                tLCD.languageCodes[tLCD.dropdownValuedest]!;
            String localLanguageCodesrc =
                tLCD.languageCodes[tLCD.dropdownValuesrc]!;
            widget.notifier.updateURL(
              widget.notifier.substr,
              localLanguageCodesrc,
              localLanguageCodedest,
            );
            print(widget.notifier.http_endpoint);
          },
          dropdownMenuEntries: tLCD.menuEntries,
        );
      },
    );
  }
}
