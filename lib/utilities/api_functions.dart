import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class ApiRequests {
  Future getApi({required String url, Map<String, dynamic>? params}) async {
    Dio dio = Dio();
    var response;
    print("URL is $url");
    bool isConnected = await checkInternet();
    if (isConnected == false) {
      print("no internet");
      ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: " No internet connection"
      );
    }
    try {
      response = await dio.get(
        url,
        queryParameters: params != null ? params : null,
        options: Options(
          headers: MyHeaders.header(),
          sendTimeout: 12000, //_defaultTimeout,
          receiveTimeout: 12000, //_defaultTimeout,
        ),
      );
      print(response.statusCode);
      print("response is ${response}");


      var jsonResponse =json.decode(response.toString());
      // var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        print("error when hit Api ${response.message}");
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(response.message),
        );
      }
    } on SocketException catch (error) {
      print('No Internet connection [SocketException]');
      print("error when hit Api ${error.message}");
      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } on HttpException catch (error) {
      print("Couldn't find the post [HttpException]");
      print("error when hit Api ${error.message}");
      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } on FormatException catch (error) {
      print("Bad response format [FormatException]");
      print("error when hit Api ${error.message}");
      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } catch (e) {
      print('[get] error ($url) -> ${e.toString()}');
      if (e is DioError) {
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(e.message),
        );
      }
    }
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (e) {
      print(e.message);
      return false;
    }
    return false;
  }
}

class ErrorResponse {
  final int errorCode;
  final String errorDescription;
  final dynamic error;

  ErrorResponse(
      {required this.errorCode, required this.errorDescription, this.error});
}

class MyHeaders {
  static Map<String, String> header() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
