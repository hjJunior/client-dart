import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:chopper/chopper.dart';
import '../omnitrade_client.dart';

String generateSignature(Request request, OmniCredentials credentials) {
  final httpVerb = request.method.toUpperCase();
  final path = '/api/v2${request.url}';
  final queryParamters = request.parameters;

  final requestPayload = utf8.encode(
    "$httpVerb|$path|${mapToQueryParameter(queryParamters)}"
  );
  final privateKey = utf8.encode(credentials.privateKey);
  final signature = Hmac(sha256, privateKey);

  return signature.convert(requestPayload).toString();
}

int get tonce => DateTime.now().millisecondsSinceEpoch;

String mapToQueryParameter(Map<String, dynamic> queryParameters) {
  List<String> query_string = [];

  queryParameters.forEach((String key, dynamic value) {
    String encoded_key = Uri.encodeComponent(key);
    String encoded_value = Uri.encodeComponent(value.toString());
    query_string.add('$encoded_key=$encoded_value');
  });

  return query_string.join('&');
}

