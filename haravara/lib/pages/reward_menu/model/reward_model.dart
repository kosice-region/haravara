class Reward {
  final String prize;
  final String code;
  final bool isUnlocked;
  final bool isClaimed;
  final String rewardKey;

  Reward({
    required this.prize,
    required this.code,
    required this.isUnlocked,
    required this.isClaimed,
    required this.rewardKey,
  });
}