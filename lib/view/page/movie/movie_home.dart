import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/view/page/movie/add_media_file.dart';

class MovieHome extends ConsumerStatefulWidget {
  const MovieHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MovieHomeState();
}

class _MovieHomeState extends ConsumerState<MovieHome> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController directorNameController = TextEditingController();
  final TextEditingController producerNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String? selectedRating = 'PG';
  List<String> tags = [];
  List<String> movieGenres = [
    'Action',
    'Adventure',
    'Comedy',
    'Thriler',
    'Sci-Fi',
    'Horror',
    'Romance',
    'Crime',
    'Drama',
    'Fantasy',
    'Mystery',
    'Musical',
    'Animation',
    'Documentary',
    'Family',
    'History',
    'Music',
    'War',
    'Western',
  ];

  List<String> movieRatings = [
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        padding: EdgeInsets.all(32.sp),
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton.filledTonal(
                onPressed: () => context.popRoute(),
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
              SizedBox(height: 90.h),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Movie Title',
                              filled: true,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 32.w),
                        Flexible(
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Add a Description',
                              filled: true,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: directorNameController,
                            decoration: const InputDecoration(
                              labelText: 'Director\'s Name',
                              filled: true,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 32.w),
                        Flexible(
                          child: TextFormField(
                            controller: producerNameController,
                            decoration: const InputDecoration(
                              labelText: 'Producer\'s Name',
                              filled: true,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    TextFormField(
                      controller: companyNameController,
                      decoration: const InputDecoration(
                        labelText: 'Production Company\'s Name',
                        filled: true,
                        // border: InputBorder.none,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    const Divider(),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            height: 230.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: const Text('Select Movie Year'),
                                ),
                                Flexible(
                                  child: YearPicker(
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2027),
                                    selectedDate: selectedDate,
                                    onChanged: (year) {
                                      setState(() {
                                        selectedDate = year;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 32.w),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            height: 230.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: const Text('Pick Movie Genres'),
                                ),
                                const Divider(),
                                ChipsChoice<String>.multiple(
                                  value: tags,
                                  choiceCheckmark: true,
                                  wrapped: true,
                                  onChanged: (val) =>
                                      setState(() => tags = val),
                                  choiceItems:
                                      C2Choice.listFrom<String, String>(
                                    source: movieGenres,
                                    value: (i, v) => v,
                                    label: (i, v) => v,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      width: 180.w,
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: const Text('Pick Movie Rating'),
                          ),
                          const Divider(),
                          DropdownButton<String>(
                            value: selectedRating,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedRating = newValue;
                              });
                            },
                            items: movieRatings
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(32.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10.r),
        ),
        width: 1.sw,
        // height: 90.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 45.h,
              child: OutlinedButton(
                onPressed: () {
                  final movieInfo = MovieInfo(
                    title: titleController.text,
                    description: descriptionController.text,
                    genres: tags,
                    rating: selectedRating ?? 'PG',
                    releaseDate: selectedDate,
                    director: directorNameController.text,
                    producer: producerNameController.text,
                    productionCompany: companyNameController.text,
                  );
                  context.pushRoute(AddMovieMediaFile(movieInfo));
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieInfo {
  final String title;
  final String description;
  final List<String> genres;
  final String productionCompany;
  final String rating;
  final DateTime releaseDate;
  final String director;
  final String producer;
  const MovieInfo({
    required this.title,
    required this.productionCompany,
    required this.description,
    required this.genres,
    required this.rating,
    required this.releaseDate,
    required this.director,
    required this.producer,
  });
  MovieInfo copyWith({
    String? title,
    String? description,
    List<String>? genres,
    String? rating,
    DateTime? releaseDate,
    String? director,
    String? producer,
    String? productionCompany,
  }) =>
      MovieInfo(
        title: title ?? this.title,
        description: description ?? this.description,
        genres: genres ?? this.genres,
        rating: rating ?? this.rating,
        releaseDate: releaseDate ?? this.releaseDate,
        director: director ?? this.director,
        producer: producer ?? this.producer,
        productionCompany: productionCompany ?? this.productionCompany,
      );
  toJson() => {
        'title': title,
        'description': description,
        'genres': genres,
        'rating': rating,
        'releaseDate': releaseDate.toIso8601String(),
        'director': director,
        'producer': producer,
        'productionCompany': productionCompany
      };
}
