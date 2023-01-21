import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:openai_client/openai_client.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Provide with ChangeNotifier {
  bool isListening = false;
  bool load = false;
  var g = 0;
  int num = 0;
  var img;
  var api = "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";
  void incnum() {
    num++;
    notifyListeners();
  }

  Future<void> getdata(String text) async {
    g = 1;
    load = false;
    img = null;
    notifyListeners();
    var url = await Uri.parse("https://api.openai.com/v1/images/generations");

    var header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $api"
    };

    var response = await http.post(url,
        headers: header,
        body: jsonEncode({'prompt': text, 'n': 1, 'size': '1024x1024'}));
    img = jsonDecode(response.body)['data'][0]['url'];
    load = true;
    print(img);
    notifyListeners();
  }
}
