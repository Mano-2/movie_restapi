import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_rest_api/model/movie.dart';
import 'package:movie_rest_api/services/http_service.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  HTTPService? _http;

  MovieService() {
    _http = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({int? page}) async {
    Response response = await _http!.get('/movie/popular', query: {
      'page': page,
    });
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load popular movies.');
    }
  }

  Future<List<Movie>> getUpcomingMovies({int? page}) async {
    Response response =
        await _http!.get('/movie/upcoming', query: {'page': page});
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> searchMovies(
    String searchTerm,
  ) async {
    Response? response = await _http!.get('/search/movie', query: {
      'query': searchTerm,
    });
    if (response.statusCode == 200) {
      Map data = response.data;
      List<Movie>? movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception('Couldn\'t perform movies search.');
    }
  }
}
