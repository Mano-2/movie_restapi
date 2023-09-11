// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_rest_api/model/main_page_data.dart';
import 'package:movie_rest_api/model/movie.dart';
import 'package:movie_rest_api/model/search_category.dart';
import 'package:movie_rest_api/services/movie_service.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.initial()) {
    getMovies();
  }
  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> movies = [];

      if (state.searchText!.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          movies = await _movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          movies = await _movieService.getUpcomingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.none) {
          movies = [];
        }
      } else {
        movies = (await _movieService.searchMovies(
          state.searchText!,
        ))!;
      }

      state = state.copyWith(
          movies: [...state.movies!, ...movies], page: state.page! + 1);
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String searchText) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: searchText);
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});

final selectedPosterUrlProvider = StateProvider<String>((ref) {
  final movie = ref.watch(mainPageDataControllerProvider).movies;
  return movie!.isNotEmpty ? movie[0].posterUrl() : '';
});
