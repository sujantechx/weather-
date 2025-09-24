import 'dart:convert';
import 'dart:io';
import 'api_exception.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  Future<dynamic> getAPI({required String url}) async {
    var uri = Uri.parse(url);
    try {
      //  OpenWeatherMap API key is sent as a query parameter,
      // not in the headers, so we don't add headers here.
      var response = await http.get(uri);
      return returnJsonResponse(response);
    } on SocketException {
      throw FetchDataException(errorMsg: "No Internet Connection");
    }
  }

  dynamic returnJsonResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var mData = jsonDecode(response.body);
        return mData;
      case 400:
        throw BadRequestException(errorMsg: response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(errorMsg: response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            errorMsg: "Error occurred with StatusCode: ${response.statusCode}");
    }
  }
}