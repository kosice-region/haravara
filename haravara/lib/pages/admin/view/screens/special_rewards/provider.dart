import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/repositories/database_repository.dart'; 


final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return DatabaseRepository();
});
