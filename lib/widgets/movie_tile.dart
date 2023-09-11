import 'package:flutter/material.dart';
import 'package:movie_rest_api/model/movie.dart';

class MovieTile extends StatelessWidget {
  final double width;
  final double height;
  final Movie movie;
  const MovieTile(
      {super.key,
      required this.width,
      required this.height,
      required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_moviePosterWidget(movie.posterUrl()), _movieInfoWidget()],
    );
  }

  SizedBox _movieInfoWidget() {
    return SizedBox(
      height: height,
      width: width * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.56,
                child: Text(
                  movie.name!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                movie.rating.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              '${movie.language!.toUpperCase()} | R: ${movie.isAdult} | ${movie.releaseDate}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.07, 0, 0),
            child: Text(
              movie.description!,
              maxLines: 7,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  Container _moviePosterWidget(String imageUrl) {
    return Container(
      height: height,
      width: width * 0.35,
      decoration:
          BoxDecoration(image: DecorationImage(image: NetworkImage(imageUrl))),
    );
  }
}
