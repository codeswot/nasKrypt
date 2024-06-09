import 'package:chips_choice/chips_choice.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/extensions.dart';
import 'package:naskrypt/model/content_info.dart';

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
  final TextEditingController screenPlayController = TextEditingController();
  final TextEditingController writersController = TextEditingController();

  final TextEditingController companyNameController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String? selectedRating = 'PG';
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

//
  List<String> categoryTags = [];
  List<String> movieCategory = [
    'Kanywood',
    'Nollywood',
    'Featured',
    'Bollywood',
    'Holywood',
  ];

//
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
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: screenPlayController,
                            decoration: const InputDecoration(
                              labelText: 'Screenplay\'s Name',
                              filled: true,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 32.w),
                        Flexible(
                          child: TextFormField(
                            controller: writersController,
                            decoration: const InputDecoration(
                              labelText: 'Writer\'s Name',
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
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
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
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
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
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: ChipsChoice<String>.multiple(
                                      value: genreTags,
                                      choiceCheckmark: true,
                                      wrapped: true,
                                      onChanged: (val) => setState(() => genreTags = val),
                                      choiceItems: C2Choice.listFrom<String, String>(
                                        source: movieGenres,
                                        value: (i, v) => v,
                                        label: (i, v) => v,
                                      ),
                                    ),
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      height: 230.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: const Text('Pick Movie Category'),
                          ),
                          const Divider(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ChipsChoice<String>.multiple(
                                value: categoryTags,
                                choiceCheckmark: true,
                                wrapped: true,
                                onChanged: (val) => setState(() => categoryTags = val),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: movieCategory,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      width: 180.w,
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
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
                            items: movieRatings.map<DropdownMenuItem<String>>((String value) {
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
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                  final movieInfo = ContentInfo(
                    title: titleController.text,
                    description: descriptionController.text,
                    genres: genreTags,
                    rating: selectedRating ?? 'PG',
                    releaseDate: selectedDate,
                    director: directorNameController.text,
                    producer: producerNameController.text,
                    productionCompany: companyNameController.text,
                    type: ContentType.movie,
                    screenPlay: screenPlayController.text,
                    writer: writersController.text,
                    actors: [],
                    category: '',
                    runtimeInMilli: 0,
                    rentPriceDuration: [],
                    isFeatured: true,
                  );

                  context.pushRoute(AddRentPriceAndDuration(movieInfo));
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

class AddRentPriceAndDuration extends StatefulWidget {
  const AddRentPriceAndDuration(this.contentInfo, {super.key});
  final ContentInfo contentInfo;
  @override
  State<AddRentPriceAndDuration> createState() => _AddRentPriceAndDurationState();
}

class _AddRentPriceAndDurationState extends State<AddRentPriceAndDuration> {
  List<RentPriceDuration> rentPriceDuration = [];
  final CurrencyTextFieldController priceController1 = CurrencyTextFieldController(
    initDoubleValue: 500,
    currencySymbol: '₦',
    decimalSymbol: '.',
    enableNegative: false,
    thousandSymbol: ',',
  );
  int duration1 = 432000000;
  final CurrencyTextFieldController priceController2 = CurrencyTextFieldController(
    initDoubleValue: 1000,
    enableNegative: false,
    currencySymbol: '₦',
    decimalSymbol: '.',
    thousandSymbol: ',',
  );
  int duration2 = 2630016000;
  bool showSecondRent = false;

  List<int> avalableDurations = [
    432000000,
    86400000,
    604800000,
    2630016000,
    7890048000,
  ];
  
  @override
  void initState() {
    rentPriceDuration.add(
      RentPriceDuration(
        price: double.tryParse(priceController1.text),
        durationInMilli: duration1,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent Price and Duration for ${widget.contentInfo.title} (${widget.contentInfo.releaseDate.year})'),
      ),
      body: Container(
        width: 1.sw,
        padding: EdgeInsets.all(32.sp),
        margin: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Text('1'),
              ),
              title: TextFormField(
                controller: priceController1,
                decoration: const InputDecoration(
                  labelText: 'Enter an amount',
                ),
              ),
              subtitle: DropdownButton<int>(
                value: duration1,
                onChanged: (int? newValue) {
                  setState(() {
                    duration1 = newValue ?? duration1;
                  });
                },
                items: avalableDurations.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toDurationString()),
                  );
                }).toList(),
              ),
            ),
            if (showSecondRent)
              ListTile(
                leading: const CircleAvatar(
                  child: Text('2'),
                ),
                title: TextFormField(
                  controller: priceController2,
                  decoration: const InputDecoration(
                    labelText: 'Enter an amount',
                  ),
                ),
                subtitle: DropdownButton<int>(
                  value: duration2,
                  onChanged: (int? newValue) {
                    setState(() {
                      duration2 = newValue ?? duration2;
                    });
                  },
                  items: avalableDurations.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toDurationString()),
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 500.h),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  rentPriceDuration = [
                    RentPriceDuration(
                      price: priceController1.doubleValue,
                      durationInMilli: duration1,
                    ),
                    if (showSecondRent)
                      RentPriceDuration(
                        price: priceController2.doubleValue,
                        durationInMilli: duration2,
                      ),
                  ];
                });
                // context.pushRoute(
                //   AddContentMediaFile(
                //     widget.contentInfo.copyWith(
                //       rentPriceDuration: rentPriceDuration,
                //     ),
                //   ),
                // );
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
      floatingActionButton: showSecondRent == false
          ? FloatingActionButton(
              onPressed: () {
                if (rentPriceDuration.length >= 2) return;
                setState(() {
                  showSecondRent = true;
                });
                rentPriceDuration.add(
                  RentPriceDuration(
                    price: double.tryParse(priceController2.text),
                    durationInMilli: duration2,
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {
                if (rentPriceDuration.length == 1) return;
                setState(() {
                  showSecondRent = false;
                });
                rentPriceDuration.remove(
                  RentPriceDuration(
                    price: double.tryParse(priceController2.text),
                    durationInMilli: duration2,
                  ),
                );
              },
              child: const Icon(Icons.remove),
            ),
    );
  }
}
