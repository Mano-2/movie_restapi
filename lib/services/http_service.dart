// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_rest_api/model/config.dart';

class HTTPService {
  final dio = Dio();
  final getIt = GetIt.instance;

  String? baseUrl;
  String? apiKey;

  HTTPService() {
    AppConfig config = getIt.get<AppConfig>();
    baseUrl = config.baseApiUrl;
    apiKey = config.apiKey;
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      String url = '$baseUrl$path';
      print(url);
      Map<String, dynamic> query0 = {'api_key': apiKey, 'language': 'en-US'};

      if (query != null) {
        query0.addAll(query);
      }
      print(query0);

      return await dio.get(url, queryParameters: query0);
    } on DioException catch (e) {
      throw Exception('Unable to preform get request DioError: $e');
    }
  }
}
