class SetupModel {
  bool isFirstSetup;
  bool isLoggedIn;
  String versionOfDatabase;

  SetupModel(
      {required this.isFirstSetup,
      required this.isLoggedIn,
      required this.versionOfDatabase});

  @override
  String toString() =>
      'SetupModel(isFirstSetup: $isFirstSetup, isLoggedIn: $isLoggedIn, versionOfDatabase: $versionOfDatabase)';
}
