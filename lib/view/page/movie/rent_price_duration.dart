import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:naskrypt/controller/build_context_extension.dart';
import 'package:naskrypt/controller/extensions.dart';
import 'package:naskrypt/model/content_info.dart';
import 'package:naskrypt/view/page/movie/encrypt_movie.dart';
import 'package:naskrypt/view/widget/app_back_button.dart';
import 'package:naskrypt/view/widget/app_text_field.dart';

class RentPriceDurationScreen extends StatefulHookConsumerWidget {
  const RentPriceDurationScreen({required this.contentInfo, super.key});
  final ContentInfo contentInfo;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RentPriceDurationScreenState();
}

class _RentPriceDurationScreenState extends ConsumerState<RentPriceDurationScreen> {
  List<RentPriceDuration> rentPriceDuration = [];
  bool showSecondRent = false;

  final CurrencyTextFieldController priceController1 = CurrencyTextFieldController(
    initDoubleValue: 500,
    currencySymbol: '₦',
    decimalSymbol: '.',
    enableNegative: false,
    thousandSymbol: ',',
  );

  final CurrencyTextFieldController priceController2 = CurrencyTextFieldController(
    initDoubleValue: 1000,
    enableNegative: false,
    currencySymbol: '₦',
    decimalSymbol: '.',
    thousandSymbol: ',',
  );

  Duration duration1 = const Duration(days: 1);
  Duration duration2 = const Duration(days: 7);

  List<Duration> availableDurations = [
    for (int i in [1, 2, 3, 4, 5, 6, 7, 14, 21, 28]) Duration(days: i)
  ];

  List<Duration> filteredDaysDuration = [];
  List<Duration> filteredWeekDuration = [];

  @override
  void initState() {
    filteredDaysDuration = availableDurations.where((duration) => duration.inDays <= 6).toList();
    filteredWeekDuration = availableDurations.where((duration) => duration.inDays >= 7).toList();
    rentPriceDuration.add(
      RentPriceDuration(
        price: double.tryParse(priceController1.text),
        durationInMilli: duration1.inMilliseconds,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(),
          SizedBox(height: 37.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 47.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: rentPriceDuration
                      .map(
                        (priceDuration) => Padding(
                          padding: EdgeInsets.only(bottom: 30.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppContentDetailTextField(
                                  controller: rentPriceDuration.indexOf(priceDuration) == 0
                                      ? priceController1
                                      : priceController2,
                                  title: 'Rent Price',
                                  hint: 'Enter Price',
                                ),
                              ),
                              SizedBox(width: 45.w),
                              Expanded(
                                child: AppContentDetailDropDown(
                                  title: 'Rent Duration',
                                  hint: 'Select Duration',
                                  value: rentPriceDuration.indexOf(priceDuration) == 0
                                      ? duration1.toDurationInDayOrWeek > 1
                                          ? '${duration1.inDays} Days'
                                          : '${duration1.inDays} Day'
                                      : duration2.toDurationInDayOrWeek > 1
                                          ? '${duration2.toDurationInDayOrWeek} Weeks'
                                          : '${duration2.toDurationInDayOrWeek} Week',
                                  onSelected: (v) {
                                    setState(() {
                                      if (rentPriceDuration.indexOf(priceDuration) == 0) {
                                        duration1 = v.toString().toDaysOrWeeksDuration();
                                      } else {
                                        duration2 = v.toString().toDaysOrWeeksDuration();
                                      }
                                    });
                                  },
                                  items: rentPriceDuration.indexOf(priceDuration) == 0
                                      ? filteredDaysDuration
                                          .map(
                                            (d) => d.inDays > 1
                                                ? '${d.toDurationInDayOrWeek} Days'
                                                : '${d.toDurationInDayOrWeek} Day',
                                          )
                                          .toList()
                                      : filteredWeekDuration
                                          .map(
                                            (d) => d.inDays > 7
                                                ? '${d.toDurationInDayOrWeek} Weeks'
                                                : '${d.toDurationInDayOrWeek} Week',
                                          )
                                          .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 32.w),
                InkWell(
                  onTap: () {
                    setState(
                      () {
                        if (rentPriceDuration.length > 1) {
                          rentPriceDuration.removeAt(rentPriceDuration.length - 1);
                        } else {
                          rentPriceDuration.add(
                            RentPriceDuration(
                              price: double.tryParse(priceController2.text),
                              durationInMilli: duration2.inMilliseconds,
                            ),
                          );
                        }
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF3A4B5D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          rentPriceDuration.length > 1 ? 'Remove' : 'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.04,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: Icon(
                            rentPriceDuration.length > 1 ? Icons.remove : Icons.add,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 55.w),
          InkWell(
            onTap: () {
              print("PRICEO Oni ${priceController1.doubleTextWithoutCurrencySymbol}");

              final selectedPriceDurations = [
                RentPriceDuration(
                  price: double.tryParse(priceController1.doubleTextWithoutCurrencySymbol.isEmpty
                          ? '500.0'
                          : priceController1.doubleTextWithoutCurrencySymbol) ??
                      500,
                  durationInMilli: duration1.inMilliseconds,
                ),
                if (rentPriceDuration.length > 1)
                  RentPriceDuration(
                    price: double.tryParse(priceController2.doubleTextWithoutCurrencySymbol.isEmpty
                            ? '1000.0'
                            : priceController2.doubleTextWithoutCurrencySymbol) ??
                        1000,
                    durationInMilli: duration2.inMilliseconds,
                  ),
              ];
              
              final addedRentPriceToContentInfo = widget.contentInfo.copyWith(
                rentPriceDuration: selectedPriceDurations,
              );
              context.pushRouteUntil(EncryptMovieScreen(contentInfo: addedRentPriceToContentInfo), (route) => false);
            },
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
                    'Encrypt',
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
    );
  }
}

class AppContentDetailDropDown extends StatelessWidget {
  const AppContentDetailDropDown({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    this.onSelected,
    this.validator,
    required this.value,
  });

  final String title;
  final String hint;
  final dynamic value;
  final List<dynamic> items;
  final Function(dynamic)? onSelected;
  final String? Function(dynamic)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            height: 0.10,
          ),
        ),
        SizedBox(height: 16.w),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<dynamic>(
            value: value,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item.toString(),
                    ),
                  ),
                )
                .toList(),
            hint: Text(hint),
            onChanged: onSelected,
            validator: validator,
            decoration: InputDecoration(
              fillColor: const Color(0xFF3A4B5D),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        )
      ],
    );
  }
}
