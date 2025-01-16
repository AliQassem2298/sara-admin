// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
// import 'package:dartz/dartz.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseUrlImage = 'http://127.0.0.1:8000';
String baseUrl = 'http://127.0.0.1:8000/api'; //////// windows

class Api {
  Future<dynamic> get({
    required String url,
    @required String? token,
  }) async {
    Map<String, String> headers = {};
    // print("My token 2 :$userToken");
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    print('url= $url ,headrs=$headers');
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print('url= $url ,headrs=$headers');

      print(data);
      return data;
    }
    // else if (response.statusCode == 404) {
    //   return [];
    // }
    else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'];
      print(message);
      throw message; ////////////////////////
    }
  }

  Future<dynamic> post({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );

    print('url= $url ,body=$body ,headers=$headers');

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      // throw Exception(
      //   'there is a problem with status code ${response.statusCode}',
      // );
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'];
      print(message);
      throw message; ////////////////////////
    }
  }

  Future<dynamic> postMultipart({
    required String url,
    required Map<String, String> fields,
    required File imageFile,
    String? token,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    request.fields.addAll(fields);

    request.files.add(
      await http.MultipartFile.fromPath('image_url', imageFile.path),
    );

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      print(responseBody);

      return jsonDecode(responseBody);
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Error: ${response.statusCode}, $responseBody');
    }
  }
}
