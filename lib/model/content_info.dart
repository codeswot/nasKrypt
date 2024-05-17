class ContentInfo {
  String title;
  String description;
  List<String> genres;
  List<String> categories;
  String rating;
  DateTime releaseDate;
  List<RentPriceDuration> rentPriceDuration;
  String director;
  String producer;
  String productionCompany;
  String screenPlay;
  String writer;
  int runtimeInMilli;
  List<String> actors;
  ContentType type;

  ContentInfo({
    required this.type,
    required this.screenPlay,
    required this.writer,
    required this.actors,
    required this.categories,
    required this.title,
    required this.description,
    required this.genres,
    required this.rating,
    required this.releaseDate,
    required this.director,
    required this.producer,
    required this.productionCompany,
    required this.rentPriceDuration,
    required this.runtimeInMilli,
  });

  factory ContentInfo.fromJson(Map<String, dynamic> json) {
    return ContentInfo(
      categories: (json['categories'] as List<dynamic>?)?.map((category) => category.toString()).toList() ?? [],
      rentPriceDuration: (json['rentPriceDuration'] as List<dynamic>?)
              ?.map((rentDuration) => RentPriceDuration.fromJson(rentDuration))
              .toList() ??
          [],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      genres: (json['genres'] as List<dynamic>?)?.map((genre) => genre.toString()).toList() ?? [],
      rating: json['rating'] ?? '',
      releaseDate: DateTime.parse(json['releaseDate']),
      director: json['director'] ?? '',
      producer: json['producer'] ?? '',
      productionCompany: json['productionCompany'] ?? '',
      type: ContentType.values.firstWhere((e) => e.name == json['type']),
      screenPlay: json['screenPlay'] ?? '',
      runtimeInMilli: json['runtime'] ?? 0,
      writer: json['writer'] ?? '',
      actors: (json['actors'] as List<dynamic>?)?.map((actor) => actor.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'title': title,
      'description': description,
      'genres': genres,
      'categories': categories,
      'type': type.name,
      'runtimeInMilli': runtimeInMilli,
      'rating': rating,
      'actors': actors,
      'director': director,
      'producer': producer,
      'screenPlay': screenPlay,
      'writer': writer,
      'productionCompany': productionCompany,
      'rentPriceDuration': rentPriceDuration.map((e) => e.toJson()).toList(),
      'releaseDate': releaseDate.toIso8601String(),


    };
  }

  @override
  String toString() {
    return 'Movie{title: $title, description: $description, genres: $genres, rating: $rating, releaseDate: $releaseDate, director: $director, producer: $producer, productionCompany: $productionCompany}';
  }

  copyWith({
    int? id,
    String? title,
    String? description,
    List<String>? genres,
    List<String>? categories,
    String? rating,
    DateTime? releaseDate,
    String? director,
    String? producer,
    String? productionCompany,
    List<RentPriceDuration>? rentPriceDuration,
    String? contentPath,
    String? thumbnailPath,
    String? posterPath,
    ContentType? type,
    String? screenPlay,
    String? writer,
    List<String>? actors,
    int? runtimeInMilli,
  }) {
    return ContentInfo(
      rentPriceDuration: rentPriceDuration ?? this.rentPriceDuration,
      title: title ?? this.title,
      description: description ?? this.description,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      releaseDate: releaseDate ?? this.releaseDate,
      director: director ?? this.director,
      producer: producer ?? this.producer,
      productionCompany: productionCompany ?? this.productionCompany,
      categories: categories ?? this.categories,
      type: type ?? this.type,
      screenPlay: screenPlay ?? this.screenPlay,
      writer: writer ?? this.writer,
      actors: actors ?? this.actors,
      runtimeInMilli: runtimeInMilli ?? this.runtimeInMilli,
    );
  }

  String toHashableString() =>
      '$title$description${genres.join(',')}$rating$director$producer$productionCompany${type.name}';
}

class RentPriceDuration {
  double? price;
  int? durationInMilli;
  RentPriceDuration({this.price, this.durationInMilli});

  factory RentPriceDuration.fromJson(Map<String, dynamic> json) {
    return RentPriceDuration(
      price: double.tryParse(json['price'].toString()) ?? 0,
      durationInMilli: int.tryParse(json['duration'].toString()) ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'duration': durationInMilli,
    };
  }
}

enum ContentType {
  movie,
  tvShow,
}

extension ContentTypeExtension on ContentType {
  // from string
  static ContentType fromString(String type) {
    return ContentType.values.firstWhere((e) => e.name.toString() == type);
  }
}
