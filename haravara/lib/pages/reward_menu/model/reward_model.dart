class Reward {
  final String prize;
  final String code;
  final bool isUnlocked;
  final bool isClaimed;
  final String rewardKey;
  final String text;
  final int color;

  Reward({
    required this.prize,
    required this.code,
    required this.isUnlocked,
    required this.isClaimed,
    required this.rewardKey,
    required this.text,
    required this.color,
  });
}