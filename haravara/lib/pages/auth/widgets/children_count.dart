import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/auth/services/auth_screen_service.dart';

class ChildrenCount extends StatefulWidget {
  const ChildrenCount({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<ChildrenCount> createState() => ChildrenCountState();
}

class ChildrenCountState extends State<ChildrenCount> {
  final List<String> children = List.generate(
      5, (index) => index == 0 ? '1 dieťa' : '${index + 1} detí');
  FocusNode _dropdownFocusNode = FocusNode();
  String? dropdownValue;

  @override
  void initState() {
    dropdownValue = children[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166.w,
      child: DropdownButtonFormField<String>(
        focusNode: _dropdownFocusNode,
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          final childrenCount = extractChildrenCount(newValue!);
          widget.onChanged(childrenCount.toString());
        },
        items: children.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          label: _dropdownFocusNode.hasFocus
              ? null
              : Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Text(
                      'POČET DETSKÝCH PÁTRAČOV',
                      style: GoogleFonts.titanOne(
                        color: Color.fromARGB(255, 188, 95, 190),
                        fontWeight: FontWeight.w300,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 188, 95, 190),
              width: 3.w,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 188, 95, 190),
              width: 3.w,
            ),
          ),
        ),
        style: GoogleFonts.titanOne(
          color: Color.fromARGB(255, 188, 95, 190),
          fontWeight: FontWeight.w300,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
