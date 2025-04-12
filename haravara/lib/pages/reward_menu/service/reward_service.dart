import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:haravara/pages/reward_menu/service/reward_code_generator.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:haravara/pages/reward_menu/model/reward_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardInfo {
  final String name;
  final int requiredStamps;
  final int color;
  final String text;

  const RewardInfo({
    required this.name,
    required this.requiredStamps,
    required this.color,
    required this.text,
  });
}

class RewardService {
  final RewardCodeGenerator _codeGenerator = RewardCodeGenerator();

  static const Map<String, Color> rewardColors = {
    'Haravara batôžtek s prekvapením': Color(0xFF9260A8),
    'Haravara pršiplášť': Color(0xFFE65F33),
    'Haravara kompas': Color(0xFF4CAF50),
    'Haravara ďalekohľad': Color(0xFF108EE6),
  };

  Future<Map<String, RewardInfo>> fetchRewardsFromDatabase() async {
    final ref = FirebaseDatabase.instance.ref('rewardDefinitions');
    final snapshot = await ref.get();
    if (!snapshot.exists || snapshot.value == null) return {};
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.map((key, value) => MapEntry(
      key,
      RewardInfo(
        name: value['name'],
        requiredStamps: value['requiredStamps'],
        color: value['color'] ,
        text: value['text'],
      ),
    ));
  }

  Future<List<Reward>> generateUserRewards(UserModel user, int collectedStamps) async {
    final prefs = await SharedPreferences.getInstance();
    final definitions = await fetchRewardsFromDatabase();
    final claimsRef = FirebaseDatabase.instance.ref('userRewards/claimedRewards/${user.id}');
    final claimedSnapshot = await claimsRef.get();
    final claimedData = claimedSnapshot.exists
        ? Map<String, dynamic>.from(claimedSnapshot.value as Map)
        : {};
    final Set<String> claimedRewardKeys = {};
    claimedData.forEach((code, data) {
      if (data is Map && data['rewardKey'] != null) {
        claimedRewardKeys.add(data['rewardKey']);
      }
    });
    List<Reward> rewards = [];
    for (var entry in definitions.entries) {
      final rewardKey = entry.key;
      final info = entry.value;
      if (claimedRewardKeys.contains(rewardKey)) {
        rewards.add(
          Reward(
            prize: info.name,
            code: '',
            isUnlocked: false,
            isClaimed: true,
            rewardKey: rewardKey,
            text:info.text,
            color:info.color,
          ),
        );
        continue;
      }
      final code = await _getOrGenerateCode(user.id, rewardKey, info.name, prefs);
      final isUnlocked = collectedStamps >= info.requiredStamps;
      if (isUnlocked) {
        final activeRef = FirebaseDatabase.instance.ref('userRewards/activeRewards/${user.id}/$rewardKey');
        final snap = await activeRef.get();
        if (snap.exists && snap.value != null) {
          final existingData = Map<String, dynamic>.from(snap.value as Map);
          existingData['rewardName'] = info.name;
          existingData['status'] = 'active';
          existingData['generated_at'] ??= DateTime.now().toIso8601String();
          await activeRef.set(existingData);
        } else {
          await activeRef.set({
            'code': code,
            'rewardName': info.name,
            'status': 'active',
            'generated_at': DateTime.now().toIso8601String(),
          });
        }
      }
      rewards.add(
        Reward(
          prize: info.name,
          code: code,
          isUnlocked: isUnlocked,
          isClaimed: false,
          rewardKey: rewardKey,
          text:info.text,
          color:info.color
        ),
      );
    }
    return rewards;
  }

  Future<void> setRewardClaimed(String rewardCode, String userId) async {
    final userActiveRef = FirebaseDatabase.instance.ref('userRewards/activeRewards/$userId');
    final activeSnapshot = await userActiveRef.get();
    if (!activeSnapshot.exists) return;
    final allActive = Map<String, dynamic>.from(activeSnapshot.value as Map);
    String? foundKey;
    Map<String, dynamic>? foundData;
    allActive.forEach((key, value) {
      if (value is Map && value['code'] == rewardCode) {
        foundKey = key;
        foundData = Map<String, dynamic>.from(value);
      }
    });
    if (foundKey == null || foundData == null) return;
    await FirebaseDatabase.instance
        .ref('userRewards/claimedRewards/$userId/$rewardCode')
        .set({
      'rewardName': foundData!['rewardName'],
      'rewardKey': foundKey,
      'code': rewardCode,
      'claimed_at': DateTime.now().toIso8601String(),
    });
    await userActiveRef.child(foundKey!).remove();
  }

  Future<String> _getOrGenerateCode(
    String userId,
    String rewardKey,
    String rewardName,
    SharedPreferences prefs,
  ) async {
    final localKey = '${userId}_$rewardKey';
    final existingLocal = prefs.getString(localKey);
    if (existingLocal != null) return existingLocal;
    final dbRef = FirebaseDatabase.instance.ref('userRewards/activeRewards/$userId/$rewardKey');
    final snapshot = await dbRef.get();
    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      if (data['code'] != null) {
        await prefs.setString(localKey, data['code']);
        return data['code'];
      }
    }
    final newCode = _codeGenerator.generateRewardCode(userId);
    await dbRef.set({
      'code': newCode,
      'rewardName': rewardName,
      'status': 'pending',
      'generated_at': DateTime.now().toIso8601String(),
    });
    await prefs.setString(localKey, newCode);
    return newCode;
  }



}
