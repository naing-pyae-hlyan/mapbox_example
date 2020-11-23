import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

const GET = 'GET';
const POST = 'POST';
const PUT = 'PUT';
const DELETE = 'DELETE';


const TYPE_APPLICATION_JSON = 'application/json';
const TYPE_MULTIPART_FORM_DATA = 'multipart/form-data';
const TYPE_X_AUTHORIZATION = 'x-authorization';



const Duration DEFAULT_TIMEOUT_DURATION = const Duration(seconds: 30);

const Map<String, String> jsonHeaders = {
  HttpHeaders.contentTypeHeader: TYPE_APPLICATION_JSON + '; charset=utf-8',
  HttpHeaders.acceptHeader: TYPE_APPLICATION_JSON,
};


Future<http.Response> getCall({
  String tag,
  String url,
  Map<String, String> headers = jsonHeaders,
  final Map<String, String> params,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  String fullUrl = url;

  if (params != null && params.isNotEmpty && params.length > 0) {
    fullUrl += '?';
    params.forEach((key, value) {
      if (fullUrl[fullUrl.length - 1] != '?') {
        fullUrl += '&';
      }
      fullUrl += key + '=' + value;
    });
  }


  final response = await http.get(fullUrl, headers: headers).timeout(
    timeoutDuration,
    onTimeout: () {
      myLog(
        tag,
        '\nRequest URL: $url'
            '\nRequest Method: GET'
            '\nRequest Headers: ${headers.toString()}'
            '\nRequest Timeout: $url',
      );

      return null;
    },
  );

  myLog(
    tag,
    '\nRequest URL: $url'
        '\nRequest Method: GET'
        '\nResponse Code: ${response.statusCode}'
        '\nResponse Body: ${response.body}',
  );

  return response;
}

Future<http.Response> postCall({
  String tag,
  String url,
  Map<String, String> headers = jsonHeaders,
  dynamic body,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  final response = await http.post(url, headers: headers, body: body).timeout(
    timeoutDuration,
    onTimeout: () {
      myLog(
        tag,
        '\nRequest URL: $url'
            '\nRequest Method: POST'
            '\nRequest Headers: ${headers.toString()}'
            '\nRequest Timeout: $url',
      );

      return null;
    },
  );

  myLog(
    tag,
    '\nRequest URL: $url'
        '\nRequest Method: POST'
        '\nRequest Headers: ${headers.toString()}'
        '\nRequest Body: $body'
        '\nResponse Code: ${response.statusCode}'
        '\nResponse Body: ${response.body}',
  );

  return response;
}

void myLog(String tag, String msg) {
  if (kReleaseMode) {
    return;
  }

  log('$tag: $msg');
}