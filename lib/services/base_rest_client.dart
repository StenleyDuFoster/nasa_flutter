import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter_nasa_app/services/api_struct.dart';

import '../entitys/base_entity.dart';
import '../main.dart';

class ResponseBlock {
  int status;
  dynamic? body;
  String error;
  ResponseBlock(this.status, this.body, this.error);
}

enum RequestType { postRequest, getRequest, delete, put }

abstract class BaseRestClient {
  const BaseRestClient();

  Future<ResponseBlock> sendRequest(RequestType type, String url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {

    headers = {};

    final basicHeader = {"Content-Type": "application/x-www-form-urlencoded"};
    if (headers != null && headers.isNotEmpty) {
      headers.addAll(basicHeader);
    } else if (!(headers?.keys?.contains("Content-Type") ?? false)) {
      headers = basicHeader;
    }

    url += "?api_key=$apiKey";

    Uri uriUrl = Uri.parse(url);

    var request;
    try {
      switch (type) {
        case RequestType.getRequest:
          request = await http.get(uriUrl, headers: headers);
          alice.onHttpResponse(request);
          break;

        case RequestType.postRequest:
          headers['Content-Type'] = 'application/json';
          final msg = jsonEncode(body);
          if (body == null) {
            request = await http.post(uriUrl, headers: headers);
          } else {
            request = await http.post(uriUrl, body: msg, headers: headers);
          }
          alice.onHttpResponse(request, body: body);
          break;

        case RequestType.put:
          headers['Content-Type'] = 'application/json';
          final msg = jsonEncode(body);
          request = await http.put(uriUrl, body: msg, headers: headers);
          alice.onHttpResponse(request, body: body);
          break;

        case RequestType.delete:
          request = await http.delete(uriUrl, headers: headers);
          alice.onHttpResponse(request);
          break;
      }

      final int status = request.statusCode;
      final bodyResponse = request.body;
      final result = ResponseBlock(status, bodyResponse, _parseError(status, bodyResponse));

      print("Response status: $status");
      print("Response body: $bodyResponse");

      return result;
    } catch (error) {
      final result = ResponseBlock(404, null, _parseError(404, "Error"));
      print("Error: $error");

      return result;
    }
  }

  Future<ResponseBlock> multipartRequest(String url,
      {Map<String, String>? headers,
      Map<String, String>? body,
      List<File>? files,
      List<String> fileNames = const ['photo'],
      Encoding? encoding}) async {

    try {
      url += "?api_key=$apiKey";
      var uri = Uri.parse(url);
      var multipartRequest;

      multipartRequest = new http.MultipartRequest('POST', uri);

      if (files != null) {
        for (var i = 0; i < files.length; ++i) {
          final image = files[i];

          if (image == null) {
            continue;
          }

          final imageName = fileNames[i];

          var stream =
              // ignore: deprecated_member_use
              http.ByteStream(DelegatingStream.typed(image.openRead()));
          var length = await image.length();
          final multipartFile = http.MultipartFile(imageName, stream, length, filename: basename(image.path));

          multipartRequest.files.add(multipartFile);
        }
      }

      multipartRequest.headers.addAll(headers);
      multipartRequest.fields.addAll(body);

      final resp = await multipartRequest.send();

      String? jsonResponse = null;

      try {
        var value = await resp.stream.bytesToString();
        print(value.toString());

        jsonResponse = value.toString();
      } catch (error) {
        print(error.toString());
      }

      final int status = resp.statusCode;
      print("Response status: $status");

      final result = ResponseBlock(status, jsonResponse, _parseError(status, null));

      return result;
    } catch (error) {
      final result = ResponseBlock(404, "", _parseError(404, "Error"));
      print("Error: $error");

      return result;
    }
  }

  parsedJson(ResponseBlock response, BaseEntity model) {
    JsonCodec codec = JsonCodec();

    try {
      var parsedJson = codec.decode(response.body);

      if (parsedJson is List<dynamic>) {
        List data = [];

        parsedJson.forEach((item) {
          var itemData = model.fromJson(item);
          if (itemData != null) {
            data.add(itemData);
          }
        });

        return data;
      } else {
        var data = model.fromJson(parsedJson);

        return data;
      }
    } catch (err) {
      print("Error: $err");
      final serverError = response.error;
      model.error = serverError;

      return model;
    }
  }

  _parseError(int status, String? body) {
    switch (status) {
      case 404:
        return "Error: Server Not Found";
      case 500:
        return "Internal Server Error";
      case 501:
        return "Not Implemented";
      case 504:
        return "Gateway Timeout";
      case 408:
        return "Request Timeout";
      case 405:
        return "Method Not Allowed";
      case 401:
        return "Unauthorized";
      case 400:
        return "Bad Request";
      case 200:
        return "";
      default:
        return "Error";
    }
  }
}
