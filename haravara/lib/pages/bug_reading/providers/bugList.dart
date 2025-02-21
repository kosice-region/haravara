import 'package:firebase_database/firebase_database.dart';

enum SortOption { newest, oldest }

class BugReport {
  String id;
  String author;
  String description;
  String expected;
  String images;
  bool solved;
  String date;
  int timestamp;
  String title;
  bool hidden;
  bool inProgress;

  BugReport({
    required this.id,
    required this.author,
    required this.description,
    required this.expected,
    required this.images,
    required this.solved,
    required this.date,
    required this.timestamp,
    required this.title,
    this.hidden = false,
    this.inProgress = false,
  });

  factory BugReport.fromMap(String id, Map<Object?, Object?>? data) {
    return BugReport(
      id: id,
      author: (data?['author'] as String?) ?? '',
      description: (data?['description'] as String?) ?? '',
      expected: (data?['expected'] as String?) ?? '',
      images: (data?['images'] as String?) ?? '',
      solved: (data?['solved'] as bool?) ?? false,
      timestamp: (data?['timestamp'] as int?) ?? 0,
      title: (data?['title'] as String?) ?? '',
      hidden: (data?['hidden'] as bool?) ?? false,
      inProgress: (data?['inProgress'] as bool?) ?? false,
      date: (data?['date']as String?) ?? ''
    );
  }
}

class BugReportService {
  final DatabaseReference _bugReportsRef =
  FirebaseDatabase.instance.ref().child('bugReports');

  Future<List<BugReport>> fetchBugReports(
      {int limit = 20, SortOption sortOption = SortOption.newest}) async {
    try {
      Query query = _bugReportsRef.orderByChild('timestamp');

      query = query.limitToLast(limit);

      final snapshot = await query.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<Object?, Object?>?;
        List<BugReport> reports = [];

        data?.forEach((key, value) {
          if (key is String && value is Map<Object?, Object?>) {
            reports.add(BugReport.fromMap(key, value));
          }
        });


        if (sortOption == SortOption.newest) {
          return reports.reversed.toList();
        } else {
          return reports;
        }

      } else {
        return [];
      }
    } catch (error) {
      print("Error fetching bug reports: $error");
      rethrow;
    }
  }

  Future<void> markBugReportAsSolved(String reportId) async {
    try {
      await _bugReportsRef.child(reportId).update({'solved': true});
      await _bugReportsRef.child(reportId).update({'inProgress': false});
    } catch (error) {
      rethrow;
    }
  }

  Future<void> hideBugReport(String reportId) async {
    try {
      await _bugReportsRef.child(reportId).update({'hidden': true});
    } catch (error) {
      rethrow;
    }
  }

  Future<void> showBugReport(String reportId) async {
    try {
      await _bugReportsRef.child(reportId).update({'hidden': false});
    } catch (error) {
      rethrow;
    }
  }

  Future<void> progressBugReport(String reportId) async {
    try {
      await _bugReportsRef.child(reportId).update({'inProgress': true});
    } catch (error) {
      rethrow;
    }
  }

}