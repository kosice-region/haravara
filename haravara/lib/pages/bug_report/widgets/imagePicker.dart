
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';

import '../view/bug_report_screen.dart';

class imgPick extends ConsumerStatefulWidget {
  final dynamic title;


  final dynamic focusNode;

  final dynamic inputType;

  final dynamic imagePathsProvider;



  const imgPick({
    Key? key,
    required this.title,

    required this.focusNode,
    required this.inputType,
    required this.imagePathsProvider,
    this.onImageSelected
  }) : super(key: key);

  final void Function(String, WidgetRef)? onImageSelected;

  @override
  ConsumerState<imgPick> createState() => _FormRowState();
}

class _FormRowState extends ConsumerState<imgPick> {
  // final ImagePicker _picker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     // Call the onImageSelected callback if provided
  //     if (widget.onImageSelected != null) {
  //       widget.onImageSelected!(image.path,ref);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) { 
    final imagePaths = ref.watch(imagePathsProvider); 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              widget.onImageSelected!(image.path,ref);
            }
          },
          child: const Text('Select Images'),
        ),
        if (imagePaths.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: imagePaths.map((imagePath) {
              return Image.asset(
                imagePath,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),
      ],
    );
  }
}