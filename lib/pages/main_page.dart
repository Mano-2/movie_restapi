// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_rest_api/controllers/main_page_data_controller.dart';
import 'package:movie_rest_api/model/movie.dart';
import 'package:movie_rest_api/model/search_category.dart';
import 'package:movie_rest_api/widgets/movie_tile.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            BackgroundWidget(
                deviceHeight: deviceHeight, deviceWidth: deviceWidth),
            _foregroundWidgets(deviceHeight, deviceWidth)
          ],
        ),
      ),
    );
  }

  Container _foregroundWidgets(double deviceHeight, double deviceWidth) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, deviceHeight * 0.02, 0, 0),
      width: deviceWidth * 0.88,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(deviceHeight, deviceWidth),
          Container(
            height: deviceHeight * 0.83,
            padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
            child: MoviesListViewWidget(
                deviceHeight: deviceHeight, deviceWidth: deviceWidth),
          )
        ],
      ),
    );
  }

  Container _topBarWidget(double deviceHeight, double deviceWidth) {
    return Container(
      height: deviceHeight * 0.08,
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchFieldWidget(
              deviceHeight: deviceHeight, deviceWidth: deviceWidth),
          const CategorySelectionWidget()
        ],
      ),
    );
  }
}

class BackgroundWidget extends ConsumerWidget {
  const BackgroundWidget({
    super.key,
    required this.deviceHeight,
    required this.deviceWidth,
  });

  final double deviceHeight;
  final double deviceWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedMoviePosterUrl = ref.watch(selectedPosterUrlProvider);
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(selectedMoviePosterUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        ),
      ),
    );
  }
}

class SearchFieldWidget extends ConsumerWidget {
  final double deviceHeight;
  final double deviceWidth;
  const SearchFieldWidget({
    super.key,
    required this.deviceHeight,
    required this.deviceWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainPageData = ref.watch(mainPageDataControllerProvider);
    final mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    final searchTextFieldController = TextEditingController();

    searchTextFieldController.text = mainPageData.searchText!;
    const border = InputBorder.none;
    return SizedBox(
      width: deviceWidth * 0.50,
      height: deviceHeight * 0.05,
      child: TextField(
        controller: searchTextFieldController,
        onSubmitted: (value) {
          print(value);
          mainPageDataController.updateTextSearch(value);
        },
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            focusedBorder: border,
            border: border,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white54,
            hintText: 'Search...'),
      ),
    );
  }
}

class CategorySelectionWidget extends ConsumerWidget {
  const CategorySelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    final mainPageData = ref.watch(mainPageDataControllerProvider);

    return DropdownButton(
      items: const [
        DropdownMenuItem(
            value: SearchCategory.popular,
            child: Text(
              SearchCategory.popular,
              style: TextStyle(color: Colors.white),
            )),
        DropdownMenuItem(
            value: SearchCategory.upcoming,
            child: Text(
              SearchCategory.upcoming,
              style: TextStyle(color: Colors.white),
            )),
        DropdownMenuItem(
            value: SearchCategory.none,
            child: Text(
              SearchCategory.none,
              style: TextStyle(color: Colors.white),
            ))
      ],
      onChanged: (value) {
        value.toString().isNotEmpty
            ? mainPageDataController.updateSearchCategory(value!)
            : null;
      },
      dropdownColor: Colors.black38,
      value: mainPageData.searchCategory,
      icon: const Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }
}

class MoviesListViewWidget extends ConsumerWidget {
  final double deviceHeight;
  final double deviceWidth;

  const MoviesListViewWidget(
      {super.key, required this.deviceHeight, required this.deviceWidth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainPageData = ref.watch(mainPageDataControllerProvider);
    final mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    final selectedMoviePosterUrl =
        ref.watch(selectedPosterUrlProvider.notifier);
    final List<Movie>? movies = mainPageData.movies;

    if (movies!.isNotEmpty) {
      return NotificationListener(
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollEndNotification) {
            final before = onScrollNotification.metrics.extentBefore;
            final max = onScrollNotification.metrics.maxScrollExtent;

            if (before == max) {
              mainPageDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
              child: GestureDetector(
                onTap: () {
                  selectedMoviePosterUrl.state = movies[index].posterUrl();
                },
                child: MovieTile(
                  width: deviceWidth * 0.85,
                  height: deviceHeight * 0.2,
                  movie: movies[index],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
