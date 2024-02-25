//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/movie.dart';


class MoviesProvider extends ChangeNotifier{

  String _apiKey = '3cae141aee991fcfef0af4f519ae1ecf';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-US';

  List <Movie> onDisplayMovies = [];
  List <Movie> popularMovies = [];

  Map <int, List <Cast>> movieCast = {};

  int _popularPage = 0; 


  MoviesProvider(){
   print('MoviesProvider inicializando');
  
    getOnDisplayMovies();
    getPopularMovies();

  }
    Future <String> _getJsonData(String endpoint, [int page = 1]) async {
      var url = Uri.https(_baseUrl, endpoint, {
        'api_key': _apiKey, 
        'language': _language,
        'page':'$page'
        });

  // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;

  }
    getOnDisplayMovies() async {
        final jsonData = await _getJsonData('3/movie/now_playing');
        final nowPlayingResponse =  NowPlayingResponse.fromJson(jsonData);
    
    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
    
  }
 getPopularMovies() async {
    _popularPage++;
    
    final jsonData = await _getJsonData('3/movie/popular');
    final popularResponse =  PopularResponse.fromJson(jsonData);
    
    popularMovies = [...popularMovies, ...popularResponse.results];
    print(popularMovies[0]);

    notifyListeners();
    
 }
Future <List<Cast>> getMovieCast (int movieId) async{
  print('pidiendo info al server -Cast');

  final jsonData = await _getJsonData('3/movie/$movieId/credits');
  final creditsResponse = CreditsResponse.fromJson(jsonData);
  
  movieCast[movieId] = creditsResponse.cast;
  return creditsResponse.cast;

}

}