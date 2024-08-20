class DistanceModel {
  double distance;
  bool isActive;
  bool wasActive;
  bool notificationSent;

  DistanceModel(
      this.distance, this.isActive, this.wasActive, this.notificationSent);

  void updateActive(bool newActiveState) {
    if (this.isActive != newActiveState) {
      this.isActive = newActiveState;
      if (!newActiveState) {
        this.wasActive = false;
        this.notificationSent = false;
      }
    }
  }
}
