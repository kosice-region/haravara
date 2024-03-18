import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/widgets/achievement.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  final List<String> sortItems = ['Opened first', 'Closed first'];
  final List<String> viewItems = ['2x2', '3x3'];
  String? selectedValueSort = 'Opened first';
  String? selectedValueView = '2x2';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return Scaffold(
      endDrawer: const HeaderMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8).r,
            child: Column(
              children: [
                const Header(showMenu: true),
                14.verticalSpace,
                Text(
                  'TVOJE PEČIATKY',
                  style: GoogleFonts.titanOne(
                      color: const Color.fromARGB(255, 86, 162, 73),
                      fontSize: 15.sp),
                ),
                10.verticalSpace,
                _buildSettings(),
                10.verticalSpace,
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final places = ref
                  .watch(placesProvider.notifier)
                  .getSortedPlaces(selectedValueSort == 'Opened first');
              return Expanded(
                child: GridView.count(
                  crossAxisCount: selectedValueView == '2x2' ? 2 : 3,
                  childAspectRatio:
                      5 / (selectedValueView == '2x2' ? 4.h : 5.h),
                  children: [
                    for (final place in places)
                      Achievement(
                        place: place,
                        size: (selectedValueView == '2x2'
                            ? ScreenSize.two
                            : ScreenSize.three),
                      ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton('Sort', Icons.sort, sortItems, true),
        20.horizontalSpace,
        _buildButton('View', Icons.view_compact, viewItems, false),
      ],
    );
  }

  Widget _buildButton(
      String text, IconData icon, List<String> items, bool isSort) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.yellow,
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: isSort ? selectedValueSort : selectedValueView,
        onChanged: (value) {
          setState(() {
            if (isSort) {
              selectedValueSort = value;
            } else {
              selectedValueView = value;
            }
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
            color: const Color.fromARGB(255, 86, 162, 73),
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_downward_sharp,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.yellow,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromARGB(255, 86, 162, 73),
          ),
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
