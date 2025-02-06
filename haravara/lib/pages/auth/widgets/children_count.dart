import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChildrenCount extends StatefulWidget {
  const ChildrenCount({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<ChildrenCount> createState() => ChildrenCountState();
}

class ChildrenCountState extends State<ChildrenCount> {
  final List<String> children = List.generate(
    5,
    (index) => index == 0 ? '1 dieťaťa' : '${index + 1} deti',
  );

  FocusNode _dropdownFocusNode = FocusNode();
  String? dropdownValue;

  @override
  void initState() {
    dropdownValue = children[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color.fromARGB(255, 24, 191, 186),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: SizedBox(
        width: 166.w,
        child: DropdownButtonFormField<String>(
          focusNode: _dropdownFocusNode,
          value: dropdownValue,
          dropdownColor: const Color.fromARGB(255, 24, 191, 186),
          iconEnabledColor: Colors.white,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: children.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
            label: _dropdownFocusNode.hasFocus
                ? null
                : Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Center(
                      child: Text(
                        'POCET DETSKYCH PATRACOV',
                        style: GoogleFonts.titanOne(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
          ),
          style: GoogleFonts.titanOne(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}
