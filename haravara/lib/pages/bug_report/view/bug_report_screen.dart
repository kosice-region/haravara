import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/pages/bug_report/services/send_report.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/core/widgets/Popup.dart';
import 'package:image_picker/image_picker.dart';

import '../../../router/router.dart';
import '../../../router/screen_router.dart';

final imagePathsProvider = StateProvider<List<String>>((ref) => []);

class BugReportScreen extends ConsumerStatefulWidget {
  const BugReportScreen({Key? key}) : super(key: key);

  @override
  _BugReportScreenState createState() => _BugReportScreenState();
}

class _BugReportScreenState extends ConsumerState<BugReportScreen> {
  final List<String> imageAssets = [
    'assets/backgrounds/background.jpg',
  ];

  bool _isLoading = false;
  var isButtonDisabled = false;
  final List<String> imagePaths = [];
  var _enteredTitle = '';
  var _enteredExpected = '';
  var _enteredDescription = '';
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _expectedFocusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expectedController = TextEditingController();

  void _submitAndValidate() async {
    if (isButtonDisabled) {
      log('Button disabled, exiting submit', name: 'BugReport');
      return;
    }
    isButtonDisabled = true;
    FocusManager.instance.primaryFocus?.unfocus();
    log('Starting report submission', name: 'BugReport');

    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chýbajuce dáta',
            content: 'Prosím, zadajte titul reportu',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chýbajuce dáta',
            content: 'Prosim, zadajte popis reportu',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }

    if (images.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chýbajuce dáta',
            content: 'Prosim, pridajte fotku',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }

    _enteredTitle = _titleController.text.trim();
    _enteredDescription = _descriptionController.text.trim();
    _enteredExpected = _expectedController.text.trim();
    log('Validated inputs - Title: $_enteredTitle, Description: $_enteredDescription',
        name: 'BugReport');

    setState(() {
      _isLoading = true;
    });

    try {
      await sendReport(_enteredTitle, _enteredDescription, _enteredExpected,
          images, context, ref);
      log('Report submission completed successfully', name: 'BugReport');
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Bug report',
            content: 'Ďakujeme za váš report',
          );
        },
      );
      ref.read(routerProvider.notifier).changeScreen(ScreenType.profile);
      ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
          context, ScreenRouter().getScreenWidget(ScreenType.news));
    } catch (e) {
      log('Error during report submission: $e', name: 'BugReport', error: e);
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chyba',
            content: 'Nepodarilo sa odoslať report. Skúste to znova.',
          );
        },
      );
    } finally {
      isButtonDisabled = false;
    }
  }

  late List<XFile> images = [];
  final picker = ImagePicker();
  bool picked = false;

  Future getImageFromGallery() async {
    final pickedFiles =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    setState(() {
      if (pickedFiles != null) {
        images.add(pickedFiles);
      }
    });
  }

  void _showExpandedImage(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                const Header(),
                Positioned(
                  top: 43.h,
                  right: 30.w,
                  child: Close_Button(
                    screenType: ScreenType.profile,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          4.h.verticalSpace,
                          Text(
                            'Nahlásiť problém',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          4.h.verticalSpace,
                          const Text('Názov Problému'),
                          TextFormField(
                            controller: _titleController,
                            focusNode: _titleFocusNode,
                            maxLength: 50,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              counterText: '',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  '${_titleController.text.trim().length}/50',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                          4.h.verticalSpace,
                          const Text('Nahrajte fotky problému'),
                          Wrap(
                            spacing: 8.0,
                            children: [
                              for (final image in images)
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          _showExpandedImage(image.path),
                                      child: Image.file(
                                        File(image.path),
                                        width: 60.w,
                                        height: 60.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              images.remove(image);
                                            });
                                          },
                                          icon: Icon(Icons.close,
                                              size: 24, color: Colors.red),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (images.length < 3)
                                Container(
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      getImageFromGallery();
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                )
                            ],
                          ),
                          4.h.verticalSpace,
                          const Text('Čo sa stalo?'),
                          TextFormField(
                            controller: _descriptionController,
                            focusNode: _descriptionFocusNode,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            maxLines: 2,
                            maxLength: 500,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              counterText: '',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${_descriptionController.text.trim().length}/500',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                          4.h.verticalSpace,
                          const Text('Čo ste očakávali?'),
                          TextFormField(
                            controller: _expectedController,
                            focusNode: _expectedFocusNode,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            maxLines: 2,
                            maxLength: 500,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              counterText: '',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${_expectedController.text.trim().length}/500',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {});
                            },
                          ),
                          4.h.verticalSpace,
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            onPressed:
                                _isLoading ? null : () => _submitAndValidate(),
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : const Text('Nahlásiť problém'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(height: 175),
    );
  }
}
