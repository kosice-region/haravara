import 'dart:math';

class RewardCodeGenerator {
  String generateRewardCode(String userId) {
    final random = Random();

    int offset = random.nextInt(10); 
    String encryptedPart = userId.substring(0, 4).toUpperCase().runes
        .map((int rune) => ((rune - 65 + offset) % 10).toString())
        .join();

    final randomPart = random.nextInt(10000).toString().padLeft(4, '0');
    final rewardCode = encryptedPart + randomPart;
    return rewardCode;
  }
}
