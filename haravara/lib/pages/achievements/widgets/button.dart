import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/pages/achievements/providers/settings_provider.dart';

class Button extends ConsumerStatefulWidget {
  const Button({
    super.key,
    required this.text,
    required this.icon,
    required this.items,
    required this.isSort,
  });

  final String text;
  final IconData icon;
  final List<String> items;
  final bool isSort;

  @override
  ConsumerState<Button> createState() => _ButtonState();
}

class _ButtonState extends ConsumerState<Button> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    var selectedValueSort =
        ref.watch(settingsProvider.notifier).getCurrentValueSort();
    var selectedValueView =
        ref.watch(settingsProvider.notifier).getCurrentValueView();

    selectedValue = widget.isSort
        ? (widget.items.contains(selectedValueSort)
            ? selectedValueSort
            : widget.items.first)
        : (widget.items.contains(selectedValueView)
            ? selectedValueView
            : widget.items.first);

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.text,
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
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
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
          );
        }).toList(),
        value: selectedValue,
        selectedItemBuilder: (BuildContext context) {
          return widget.items.asMap().entries.map((entry) {
            String item = entry.value;
            return Row(
              children: [
                Icon(
                  widget.icon,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }).toList();
        },
        onChanged: (value) {
          if (widget.isSort) {
            ref.read(settingsProvider.notifier).toggleValueSort(value!);
          } else {
            ref.read(settingsProvider.notifier).toggleValueView(value!);
          }
          setState(() {});
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color.fromARGB(255, 255, 255, 255),
              width: 3.0,
            ),
            color: const Color(0xFF1666B1),
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_downward_sharp,
          ),
          iconSize: 14,
          iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
              width: 2.0,
            ),
            color: const Color(0xFF67B5E1),
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
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
