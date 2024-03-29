import "package:flutter/material.dart";
import "package:peliculas/models/movie.dart";

class MoviesSlider extends StatefulWidget {
  const MoviesSlider({super.key, 
  required this.movies, 
  required this.title, 
  required this.onNextPage
  });

  final List <Movie> movies; 
  final String title;  
  final Function onNextPage;

  @override
  State<MoviesSlider> createState() => _MoviesSliderState();
}

class _MoviesSliderState extends State<MoviesSlider> {
final ScrollController scrollController =  ScrollController();

@override
  void initState(){
  super.initState();
  scrollController.addListener(() {
    if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
      widget.onNextPage();
    }    

     
  });
}

@override
  void dispose(){
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if(widget.title != null)
          Padding (
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
          ),

          SizedBox(height: 5),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (BuildContext context , int index) => _MoviePoster(widget.movies[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: 130,
                  height: 190,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [

                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage(
                            placeholder: const AssetImage('assets/no-image.jpg'), 
                            image: NetworkImage(movie.fullPosterImg),
                            width: 130,
                            height: 190,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: 5),
                      Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
  }
}