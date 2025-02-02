import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();
  static ApiService instance = ApiService._();

  Future<String> sendUserImage({required File image}) async {
    Uri url = Uri.parse('https://api.imgur.com/3/image');

    Uint8List imageList = await image.readAsBytes();

    String userImage = base64Encode(imageList);

    String userURL =
        "https://i.pinimg.com/736x/93/e8/d0/93e8d0313894ff752ef1c6970116bad6.jpg";

    http.Response res = await http.post(
      url,
      headers: {
        'Authorization': "Client-ID 53ae945a618bd24",
      },
      body: userImage,
    );

    log("Status Code : ${res.statusCode}");
    if (res.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(res.body);

      log("Response Data : ${data['data']['link']}");
      userURL = data['data']['link'];
    }

    return userURL;
  }
}
