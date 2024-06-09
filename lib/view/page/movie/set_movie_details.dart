import 'package:chips_choice/chips_choice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/extensions.dart';
import 'package:naskrypt/model/content_info.dart';
import 'package:naskrypt/view/page/movie/rent_price_duration.dart';
import 'package:naskrypt/view/widget/app_back_button.dart';
import 'package:naskrypt/view/widget/app_text_field.dart';
import 'package:naskrypt/view/widget/movie_file_card.dart';
import 'package:naskrypt/view/widget/picker_background.dart';

class SetMovieDetails extends StatefulWidget {
  const SetMovieDetails(this.filePath, {super.key});
  final String filePath;
  @override
  State<SetMovieDetails> createState() => _SetMovieDetailsState();
}

class _SetMovieDetailsState extends State<SetMovieDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //
  final TextEditingController movieTitleController = TextEditingController();
  final TextEditingController movieDescriptionController = TextEditingController();
  final TextEditingController movieDirectorController = TextEditingController();
  final TextEditingController movieProducerController = TextEditingController();
  final TextEditingController productionCompanyController = TextEditingController();
  final TextEditingController screenPlayController = TextEditingController();
  final TextEditingController writerController = TextEditingController();
  //
  DateTime selectedDateYear = DateTime.now();
  //
  List<String> genreTags = [];
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

  String selectedRating = 'PG';
  List<String> ratings = [];
  String selectedCategory = 'Kanywood';
  List<String> categories = [];
  //
  bool isMovieFeatured = false;
  String? selectedThumbnailPath;
  @override
  void initState() {
    ratings.addAll(
      [
        'G',
        selectedRating,
        'PG-13',
        'R',
        'NC-17',
      ],
    );

    categories.addAll(
      [
        selectedCategory,
        'Nollywood',
        'Bollywood',
        'Holywood',
      ],
    );
    super.initState();
  }

  bool showGenreError = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 47.w, vertical: 15.w),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 80.w),
                      MovieFileCard(filePath: widget.filePath),
                      SizedBox(height: 44.w),
                      Row(
                        children: [
                          Flexible(
                            child: AppContentDetailTextField(
                              controller: movieTitleController,
                              title: 'Movie Title',
                              hint: 'Enter movie title',
                              onValidate: (v) {
                                if (v?.isEmpty == true) {
                                  return 'Please enter movie title';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 45.w),
                          Flexible(
                            child: AppContentDetailTextField(
                              controller: movieDescriptionController,
                              title: 'Add description',
                              hint: 'Enter description',
                              onValidate: (v) {
                                if (v?.isEmpty == true) {
                                  return 'Please enter movie description';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        children: [
                          Flexible(
                            child: AppContentDetailTextField(
                              controller: movieDirectorController,
                              title: 'Director Name',
                              hint: 'Enter director name',
                              onValidate: (v) {
                                if (v?.isEmpty == true) {
                                  return 'Please enter movie director\'s name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 45.w),
                          Flexible(
                            child: AppContentDetailTextField(
                              controller: movieProducerController,
                              title: 'Producer Name',
                              hint: 'Enter producer name',
                              onValidate: (v) {
                                if (v?.isEmpty == true) {
                                  return 'Please enter movie producer\'s name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        children: [
                          Flexible(
                            child: AppContentDetailTextField(
                              controller: productionCompanyController,
                              title: 'Production Company',
                              hint: 'Enter product company',
                              onValidate: (v) {
                                if (v?.isEmpty == true) {
                                  return 'Please enter movie production company';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 45.w),
                          Flexible(
                            child: AppContentDetailTextField(
                              controller: screenPlayController,
                              title: 'Screen Play',
                              hint: 'Enter screen name',
                              onValidate: (v) {
                                if (v?.isEmpty == true) {
                                  return 'Please enter movie screenplay\'s name';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        children: [
                          Flexible(
                            child: AppContentDetailTextField(
                              controller: writerController,
                              title: 'Writer',
                              hint: 'Enter writer name',
                              onValidate: (v) {
                                if (v?.isEmpty == true) {
                                  return 'Please enter movie writer\'s name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 45.w),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Movie Thumbnail',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    height: 0.10,
                                  ),
                                ),
                                SizedBox(height: 16.w),
                                InkWell(
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                    );
                                    if (result != null) {
                                      setState(() {
                                        selectedThumbnailPath = result.files.single.path;
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Container(
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3A4B5D),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: const Color(0xFFCFD4DC), width: 1.w),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: selectedThumbnailPath != null
                                                ? Padding(
                                                    padding: EdgeInsets.only(left: 10.w),
                                                    child: Text(
                                                      '$selectedThumbnailPath'.toVisualFileName,
                                                    ),
                                                  )
                                                : const SizedBox.shrink()),
                                        Container(
                                          height: 65.h,
                                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.w),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF3A4B5D),
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8.r),
                                              topRight: Radius.circular(8.r),
                                            ),
                                            border: Border(
                                              left: BorderSide(
                                                width: 1.w,
                                                color: const Color(0xFFCFD4DC),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 20.w,
                                                height: 20.w,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(),
                                                child: Icon(
                                                  Icons.file_open,
                                                  size: 20.w,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Click upload thumbail',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontFamily: 'Satoshi',
                                                  fontWeight: FontWeight.w500,
                                                  height: 0.09,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Movie Year',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    // height: 0.10,
                                  ),
                                ),
                                SizedBox(height: 6.w),
                                SizedBox(
                                  width: 1.sw,
                                  height: 247.w,
                                  child: PickerBackground(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                                      child: YearPicker(
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now().add(const Duration(days: 730)),
                                        selectedDate: selectedDateYear,
                                        currentDate: DateTime.now(),
                                        onChanged: (yearDate) {
                                          setState(() {
                                            selectedDateYear = yearDate;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6.w),
                                  child: SizedBox(height: 20.w),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 45.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Movie Genre',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    // height: 0.10,
                                  ),
                                ),
                                SizedBox(height: 6.w),
                                SizedBox(
                                  width: 1.sw,
                                  height: 247.w,
                                  child: PickerBackground(
                                    errorBorder: showGenreError,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                                      child: SingleChildScrollView(
                                        child: ChipsChoice<String>.multiple(
                                          value: genreTags,
                                          choiceCheckmark: true,
                                          wrapped: true,
                                          onChanged: (val) {
                                            setState(() {
                                              genreTags = val;
                                            });
                                            if (genreTags.isNotEmpty) {
                                              showGenreError = false;
                                            } else {
                                              showGenreError = true;
                                            }
                                          },
                                          choiceItems: C2Choice.listFrom<String, String>(
                                            source: movieGenres,
                                            value: (i, v) => v,
                                            label: (i, v) => v,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 6.w),
                                  child: SizedBox(
                                    height: 20.w,
                                    child: showGenreError
                                        ? Text(
                                            'At least one genre is required',
                                            style: TextStyle(
                                              color: const Color(0xffFFB4AA),
                                              fontSize: 13.sp,
                                              fontFamily: 'Satoshi',
                                              fontWeight: FontWeight.w500,
                                              // height: 0.10,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Movie Category',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    // height: 0.10,
                                  ),
                                ),
                                SizedBox(height: 6.w),
                                SizedBox(
                                  width: 1.sw,
                                  height: 247.w,
                                  child: PickerBackground(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 130.w),
                                      child: ChipsChoice<String>.single(
                                        value: selectedCategory,
                                        choiceCheckmark: false,
                                        wrapped: true,
                                        wrapCrossAlignment: WrapCrossAlignment.center,
                                        alignment: WrapAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        onChanged: (val) => setState(() => selectedCategory = val),
                                        choiceItems: C2Choice.listFrom<String, String>(
                                          source: categories,
                                          value: (i, v) => v,
                                          label: (i, v) => v,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 45.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Movie Rating',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    // height: 0.10,
                                  ),
                                ),
                                SizedBox(height: 6.w),
                                SizedBox(
                                  width: 1.sw,
                                  height: 247.w,
                                  child: PickerBackground(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 130.w),
                                      child: ChipsChoice<String>.single(
                                        value: selectedRating,
                                        choiceCheckmark: true,
                                        wrapped: true,
                                        wrapCrossAlignment: WrapCrossAlignment.center,
                                        alignment: WrapAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        onChanged: (val) => setState(() => selectedRating = val),
                                        choiceItems: C2Choice.listFrom<String, String>(
                                          source: ratings,
                                          value: (i, v) => v,
                                          label: (i, v) => v,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 1.sw,
                              child: PickerBackground(
                                child: CheckboxListTile.adaptive(
                                    value: isMovieFeatured,
                                    onChanged: (v) {
                                      setState(() {
                                        isMovieFeatured = v ?? false;
                                      });
                                    },
                                    title: Text(
                                      'Featured Movie',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w500,
                                        // height: 0.10,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(width: 45.w),
                          const Expanded(child: SizedBox.shrink()),
                        ],
                      ),
                      SizedBox(height: 55.w),
                      InkWell(
                        onTap: _submitMovieForm,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  color: const Color(0xFF000710),
                                  fontSize: 18.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0.12,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const Icon(
                                  Icons.arrow_right_alt,
                                  color: Color(0xFF000710),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 55.w),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _submitMovieForm() {
    if (genreTags.isEmpty) {
      setState(() {
        showGenreError = true;
      });
    } else {
      setState(() {
        showGenreError = false;
      });
    }
    if ((_formKey.currentState!.validate() && genreTags.isNotEmpty)) {
      _formKey.currentState!.save();
      ContentInfo contentInfo = ContentInfo(
        type: ContentType.movie,
        title: movieTitleController.text,
        description: movieDescriptionController.text,
        rating: selectedRating,
        releaseDate: selectedDateYear,
        producer: movieProducerController.text,
        productionCompany: productionCompanyController.text,
        screenPlay: screenPlayController.text,
        writer: writerController.text,
        director: movieDirectorController.text,
        genres: genreTags,
        isFeatured: isMovieFeatured,
        category: selectedCategory,
        contentPath: widget.filePath,
        thumbnailPath: selectedThumbnailPath,
        rentPriceDuration: [],
        runtimeInMilli: 0,
        actors: [],
      );
      context.pushRoute(
        RentPriceDurationScreen(
          contentInfo: contentInfo,
        ),
      );
    }
  }
}
