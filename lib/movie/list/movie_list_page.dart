import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie/movie/list/movie.dart';
import 'package:flutter_movie/movie/detail/movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  MovieListPageState createState() => new MovieListPageState();
}

class MovieListPageState extends State<MovieListPage> {
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    getMovieListData();
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (_movies.isEmpty) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new ListView.builder(
        itemCount: _movies.length,
        itemBuilder: _buildMovieItem,

      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('吴小龙同學'),
      ),
      body: content,

    );
  }

  // 跳转页面
  navigateToMovieDetailPage(Movie movie, Object imageTag) {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (c) {
              return new MovieDetailPage(movie, imageTag: imageTag);
            }
        )
    );
  }

  getMovieListData() async {
    //createHttpClient() 来自 package:flutter/services.dart，居然不能自己导包。
    String response = await createHttpClient().read(
        'https://api.douban.com/v2/movie/in_theaters?'
            'apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8C%97%E4%BA%AC&'
            'start=0&count=100&client=&udid=');

    setState(() {
      _movies = Movie.allFromResponse(response);
    });
  }


  _buildMovieItem(BuildContext context, int index) {
    Movie movie = _movies[index];

    var movieImage = new Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 10.0,
      ),
      child: new Image.network(
        movie.smallImage,
        width: 100.0,
        height: 120.0,),
    );

    var movieMsg = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          movie.title,
          textAlign: TextAlign.left,
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14.0
          ),
        ),
        new Text('导演：' + movie.director),
        new Text('主演：' + movie.cast),
        new Text('评分：' + movie.average),
        new Text(
          movie.collectCount.toString() + '人看过',
          style: new TextStyle(
            fontSize: 12.0,
            color: Colors.redAccent,),
        ),
      ],
    );

    var movieItem = new GestureDetector(
      onTap: () => navigateToMovieDetailPage(movie, index),

      child: new Column(

        children: <Widget>[
          new Row(

            children: <Widget>[
              movieImage,
              //Expanded 均分
              new Expanded(
                child: movieMsg,
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
          new Divider(),
        ],),

    );

    return movieItem;
  }
}