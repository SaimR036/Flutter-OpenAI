import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:openai_client/openai_client.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'provide_page.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => (Provide()))],
      child: MaterialApp(home: MyApp())));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final cachemanage = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      fileService: HttpFileService(),
    ),
  );
  int num = 0;
  bool _speechEnabled = false;
  String _lastWords = '';
  bool speaking = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  String y = 'lol';
  TextEditingController x = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<Provide>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          OrientationBuilder(builder: ((context, orientation) {
            return orientation == Orientation.portrait
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 80, 0),
                    child: IconButton(
                        onPressed: () async {
                          speaking = !speaking;

                          if (!_isListening) {
                            bool available = await _speech.initialize(
                              onStatus: (val) async {
                                if (val == "done") {
                                  print("final");
                                  setState(() {
                                    _isListening = false;
                                  });
                                  Future.delayed(Duration(seconds: 2),
                                      () async {
                                    await pro.getdata(_lastWords);
                                  });
                                }
                                print('onStatus: $val');
                              },
                              onError: (val) => print('onError: $val'),
                            );
                            if (available) {
                              setState(() {
                                _isListening = true;
                              });
                              _speech.listen(onResult: (val) async {
                                print("uasdasdad");
                                _lastWords = await val.recognizedWords;
                                setState(() {
                                  _lastWords;
                                });
                              });
                            }
                          }
                          //Future.delayed(Duration(seconds: 3), () async {
                          print("num is ${num}");
                          // if (num == 1 && _lastWords != '') {
                          //  await pro.getdata(_lastWords);
                          // setState(() => num = 0);
                          //}
                          // });

                          ;
                        },
                        icon:
                            _isListening ? Icon(Icons.stop) : Icon(Icons.mic)),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 80, 0),
                    child: IconButton(
                        onPressed: () async {
                          speaking = !speaking;

                          if (!_isListening) {
                            bool available = await _speech.initialize(
                              onStatus: (val) async {
                                if (val == "done") {
                                  print("final");
                                  setState(() {
                                    _isListening = false;
                                  });
                                  Future.delayed(Duration(seconds: 2),
                                      () async {
                                    await pro.getdata(_lastWords);
                                  });
                                }
                                print('onStatus: $val');
                              },
                              onError: (val) => print('onError: $val'),
                            );
                            if (available) {
                              setState(() {
                                _isListening = true;
                              });
                              _speech.listen(onResult: (val) async {
                                print("uasdasdad");
                                _lastWords = await val.recognizedWords;
                                setState(() {
                                  _lastWords;
                                });
                              });
                            }
                          }
                          //Future.delayed(Duration(seconds: 3), () async {
                          print("num is ${num}");
                          // if (num == 1 && _lastWords != '') {
                          //  await pro.getdata(_lastWords);
                          // setState(() => num = 0);
                          //}
                          // });

                          ;
                        },
                        icon:
                            _isListening ? Icon(Icons.stop) : Icon(Icons.mic)),
                  );
          })),
          OrientationBuilder(builder: ((context, orientation) {
            return orientation == Orientation.portrait
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(50, 70, 80, 0),
                    child: Text('$_lastWords'))
                : Padding(
                    padding: const EdgeInsets.fromLTRB(50, 32, 80, 0),
                    child: Text('$_lastWords'));
          })),
          OrientationBuilder(builder: ((context, orientation) {
            return orientation == Orientation.portrait
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(50, 90, 0, 0),
                    child: Divider(
                      color: Colors.black26,
                      thickness: 2,
                    ))
                : Padding(
                    padding: const EdgeInsets.fromLTRB(50, 50, 60, 0),
                    child: Divider(
                      color: Colors.black26,
                      thickness: 2,
                    ));
          })),
          if (pro.g != 0)
            pro.load == false
                ? OrientationBuilder(builder: ((context, orientation) {
                    return orientation == Orientation.portrait
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(200, 400, 0, 0),
                            child: CircularProgressIndicator(
                              color: Colors.blueGrey,
                              strokeWidth: 2,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(380, 220, 0, 0),
                            child: CircularProgressIndicator(
                              color: Colors.blueGrey,
                              strokeWidth: 2,
                            ),
                          );
                  }))
                : OrientationBuilder(builder: ((context, orientation) {
                    return orientation == Orientation.portrait
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                            child: Container(
                                //height: 700,
                                child: CachedNetworkImage(
                              imageUrl: pro.img,
                              key: UniqueKey(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 650,
                                width: 500,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              cacheManager: cachemanage,
                              placeholder: (context, url) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(200, 250, 0, 0),
                                child: CircularProgressIndicator(
                                  color: Colors.blueGrey,
                                  strokeWidth: 2,
                                ),
                              ),
                            )))
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                            child: Container(
                                //height: 700,
                                child: CachedNetworkImage(
                              imageUrl: pro.img,
                              key: UniqueKey(),
                              imageBuilder: (context, imageProvider) => Padding(
                                padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                                child: Container(
                                  height: 400,
                                  width: 680,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              cacheManager: cachemanage,
                              placeholder: (context, url) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(380, 150, 0, 0),
                                child: CircularProgressIndicator(
                                  color: Colors.blueGrey,
                                  strokeWidth: 2,
                                ),
                              ),
                            )));
                  }))
        ],
      ),
    );
  }

  Future<int> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == "done") {
            print("final");
          }
          print('onStatus: $val');
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (val) async {
          print("uasdasdad");
          _lastWords = await val.recognizedWords;
          setState(() {
            _lastWords;
            num = 1;
            _isListening = false;
          });
        });
      }
    } else {
      setState(() {
        num = 1;
        _isListening = false;
        ;
      });
    }
    return 0;
  }
}
