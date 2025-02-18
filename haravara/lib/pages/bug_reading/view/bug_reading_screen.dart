import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/router/router.dart';

import '../providers/bugList.dart';


final imagePathsProvider = StateProvider<List<String>>((ref) => []);

enum BugReportStatus { all, unsolved, solved , hidden , inProgress}

class BugReadingScreen extends ConsumerStatefulWidget {
  const BugReadingScreen({Key? key}) : super(key: key);

  @override
  _BugReadingState createState() => _BugReadingState();
}

class _BugReadingState extends ConsumerState<BugReadingScreen> {
  final List<String> imageAssets = [
    'assets/backgrounds/background.jpg',
  ];

  var isButtonDisabled = false;
  List<String> imagePaths = [];
  List<BugReport> _bugReports = [];
  bool _isLoading = true;
  String? _errorMessage;
  int titleLength = 20;
  String? _expandedReportId;
  int _reportsLimit = 20;
  SortOption _currentSortOption = SortOption.newest;
  BugReportStatus _currentStatusFilter = BugReportStatus.all;



  final BugReportService _bugReportService = BugReportService();

  @override
  void initState() {
    super.initState();
    _loadBugReports();

  }


  Future<void> _loadBugReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _expandedReportId = null;
    });

    try {
      final reports = await _bugReportService.fetchBugReports(
        limit: _reportsLimit,
        sortOption: _currentSortOption,
      );


      List<BugReport> bugReports;
      if (_currentStatusFilter == BugReportStatus.all) {
        //All
        bugReports = reports.where((report) => !report.hidden).toList();
      } else if(_currentStatusFilter == BugReportStatus.solved){
        //Solved
        bugReports = reports.where((report) => report.solved  && !report.hidden).toList();
      } else if(_currentStatusFilter == BugReportStatus.inProgress){
        //InProgress
        bugReports = reports.where((report) => report.inProgress  && !report.hidden).toList();
      } else if (_currentStatusFilter == BugReportStatus.unsolved) {
        //Unsolved
        bugReports = reports.where((report) => !report.solved && !report.hidden).toList();
      }  else {
        //Hidden
        bugReports = reports.where((report) => report.hidden).toList();
      }

      setState(() {
        _bugReports = bugReports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load bug reports: $e";
      });
      print("Error loading bug reports: $e");
    }
  }

  Future<void> _loadImageUrls(String reportId) async {
    if (_expandedReportId != reportId) return;

    try {
      imagePaths = [];
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/bug-reports/$reportId');
      final ListResult result = await storageRef.listAll();
      List<String> urls = [];
      for (final Reference ref in result.items) {
        final downloadUrl = await ref.getDownloadURL();
        urls.add(downloadUrl);
      }

      if (_expandedReportId == reportId) {
        setState(() {
          imagePaths = urls;
        });
      }
    } catch (e) {
      print("Error loading images for report $reportId: $e");
      if (_expandedReportId == reportId) {
        setState(() {
          imagePaths = [];
          _errorMessage = "Failed to load images for this report.";
        });
      }
    }
  }

  Future<void> _progressProblem(String reportId,String action) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if(action=="hide"){
        await _bugReportService.hideBugReport(reportId);
      }else if (action == "close"){
        await _bugReportService.markBugReportAsSolved(reportId);
        await _bugReportService.markBugReportAsSolved(reportId);
      }else if(action == "progress"){
        await _bugReportService.progressBugReport(reportId);
      }

      await _loadBugReports();
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to close problem: $e";
        _isLoading = false;
      });
      print("Error closing problem: $e");
    }
  }

  void _showExpandedImage(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.network(imagePath),
        ),
      ),
    );
  }



  Widget _buildImageGrid(String reportId) {
    if (reportId != _expandedReportId) {
      return SizedBox.shrink();
    }

    if (imagePaths.isEmpty && _errorMessage == null) {
      return CircularProgressIndicator();
    }
    if (imagePaths.isEmpty && _errorMessage != null) {
      return Text(_errorMessage!);
    }

    return Wrap(
      spacing: 8.0,
      children: [
        for (final imageUrl in imagePaths)
          GestureDetector(
            onTap: () => _showExpandedImage(imageUrl),
            child: Image.network(
              imageUrl,
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),
      ],
    );
  }

  Widget _buildReportList() {
    if (_bugReports.isEmpty) {
      return Center(child: Text("Nenašli sa nahlasenia."));
    }

    bool showLoadMore = _bugReports.length >= _reportsLimit;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _bugReports.length,
            itemBuilder: (context, index) {
              final report = _bugReports[index];
              final bool isExpanded = _expandedReportId == report.id;

              return Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 8.0,
                  color: !report.solved ? report.inProgress ? Colors.orangeAccent : Colors.redAccent : Colors.greenAccent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        4.h.verticalSpace,
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedReportId = null;
                              } else {
                                _expandedReportId = report.id;
                                _loadImageUrls(report.id);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  report.title.length <= titleLength?  report.title  :report.title.substring(0, titleLength) + "...",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more),
                            ],
                          ),
                        ),
                        if (isExpanded) ...[
                          4.h.verticalSpace,
                          const Text('Názov Problému'),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black12,
                            width: double.infinity,
                            child: Text(report.title),
                          ),
                          4.h.verticalSpace,
                          const Text('Nahraté fotky problému'),
                          _buildImageGrid(report.id),
                          4.h.verticalSpace,
                          const Text('Čo sa stalo?'),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black12,
                            width: double.infinity,
                            child: Text(report.description),
                          ),
                          4.h.verticalSpace,
                          const Text('Čo ste očakávali?'),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black12,
                            width: double.infinity,
                            child: Text(report.expected),
                          ),
                          4.h.verticalSpace,
                          const Text('Autor'),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black12,
                            width: double.infinity,
                            child: Text(report.author),
                          ),
                          4.h.verticalSpace,
                          const Text('Datum Nahlasenia'),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.black12,
                            width: double.infinity,
                            child: Text(report.date.toString()),
                          ),
                          4.h.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (!report.solved) ...[
                                report.inProgress
                                    ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                      foregroundColor: Colors.white),
                                  onPressed: () => _progressProblem(report.id, "close"),
                                  child: const Text('Zavri problem'),
                                )
                                    : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      foregroundColor: Colors.white),
                                  onPressed: () => _progressProblem(report.id, "progress"),
                                  child: const Text('Oznac problem'),
                                ),
                              ],
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue, foregroundColor: Colors.white),
                                onPressed: () => _progressProblem(report.id, "hide"),
                                child: const Text('Schovaj problem'),
                              ),
                            ],
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (showLoadMore)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _reportsLimit += 20;
                });
                _loadBugReports();
              },
              child: Text('Load More'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
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
                    screenType: ScreenType.admin,
                  ),
                ),
              ],
            ),

            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<BugReportStatus>(
                    value: _currentStatusFilter,
                    onChanged: (BugReportStatus? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _currentStatusFilter = newValue;
                          _loadBugReports();
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: BugReportStatus.all,
                        child: Text("All"),
                      ),
                      DropdownMenuItem(
                        value: BugReportStatus.unsolved,
                        child: Text("Unsolved"),
                      ),
                      DropdownMenuItem(
                        value: BugReportStatus.solved,
                        child: Text("Solved"),
                      ),
                      DropdownMenuItem(
                        value: BugReportStatus.inProgress,
                        child: Text("InProgress"),
                      ),
                      DropdownMenuItem(
                        value: BugReportStatus.hidden,
                        child: Text("Hidden"),
                      ),
                    ],
                    underline: SizedBox(),
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  ),
                ),


                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<SortOption>(
                    value: _currentSortOption,
                    onChanged: (SortOption? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _currentSortOption = newValue;
                          _loadBugReports();
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: SortOption.newest,
                        child: Text("Newest"),
                      ),
                      DropdownMenuItem(
                        value: SortOption.oldest,
                        child: Text("Oldest"),
                      ),
                    ],
                    underline: SizedBox(),
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  ),
                ),
              ],
            ),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator()) : _buildReportList(),

            ),
          ],
        ),
      ),
    );
  }
}