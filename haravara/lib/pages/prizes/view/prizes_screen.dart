import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/pages/reward_menu/model/reward_model.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';

import '../../../core/widgets/close_button.dart';

class PrizesScreen extends ConsumerStatefulWidget {
  const PrizesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PrizesScreen> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends ConsumerState<PrizesScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> claimedRewardsData = [];

  static const Map<String, Color> _rewardColors = {
    'reward1': Color(0xFF9260A8),
    'reward2': Color(0xFFE65F33),
    'reward3': Color(0xFF4CAF50),
    'reward4': Color(0xFF2196F3),
  };

  @override
  void initState() {
    super.initState();
    _fetchClaimedRewards();
  }

  Future<void> _fetchClaimedRewards() async {
    setState(() => isLoading = true);
    try {
      final userState = ref.read(userInfoProvider);
      final userId = userState.id;
      if (userId.isEmpty) {
        setState(() {
          claimedRewardsData = [];
          isLoading = false;
        });
        return;
      }

      final claimedRef =
          FirebaseDatabase.instance.ref('userRewards/claimedRewards/$userId');
      final snapshot = await claimedRef.get();

      if (!snapshot.exists || snapshot.value == null) {
        setState(() {
          claimedRewardsData = [];
          isLoading = false;
        });
        return;
      }

      final dataMap = Map<String, dynamic>.from(snapshot.value as Map);
      final tempList = <Map<String, dynamic>>[];

      dataMap.forEach((codeKey, claimData) {
        if (claimData is Map) {
          final rewardName = claimData['rewardName'] ?? 'Unknown Reward';
          final rewardKey = claimData['rewardKey'] ?? '';
          final rewardCode = claimData['code'] ?? codeKey;
          final claimedAt = claimData['claimed_at'] ?? '';

          final reward = Reward(
            prize: rewardName,
            code: rewardCode,
            isUnlocked: false,
            isClaimed: true,
            rewardKey: rewardKey,
            text:"test2",
            color:Colors.grey.value,
          );

          tempList.add({
            'reward': reward,
            'claimedAt': claimedAt,
          });
        }
      });

      setState(() {
        claimedRewardsData = tempList;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Color _getRewardColor(String rewardKey) {
    if (_rewardColors.containsKey(rewardKey)) {
      return _rewardColors[rewardKey]!;
    }

    int hash = rewardKey.runes.fold(0, (prev, element) => prev * 31 + element);
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);

    return Color.fromARGB(255, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/background.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned(
            top: 22.h,
            left: 0,
            right: 0,
            child: const Header(),
          ),
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(),
          ),
          Positioned(
            top: 120.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    width: 0.65.sw,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 24, 191, 186),
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(color: Colors.white, width: 4.w),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Text(
                            'VÝHRY',
                            style: GoogleFonts.titanOne(
                              fontSize: 20.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          top: -12.h,
                          right: -12.w,
                          child: Image.asset(
                            'assets/MINCE.png',
                            width: 30.w,
                            height: 30.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 3.h,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                SizedBox(height: 5.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : claimedRewardsData.isEmpty
                            ? Center(
                                child: Text(
                                  'Žiadne vyzbierané ceny.',
                                  style: GoogleFonts.titanOne(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(bottom: 50.h),
                                itemCount: claimedRewardsData.length,
                                itemBuilder: (context, index) {
                                  final item = claimedRewardsData[index];
                                  final reward = item['reward'] as Reward;
                                  final claimedAt = item['claimedAt'] as String;
                                  return Center(
                                    child: _buildSingleContainer(
                                        reward, claimedAt),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Footer(height: 175, boxFit: BoxFit.fill),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleContainer(Reward reward, String claimedAt) {
    final containerColor = _getRewardColor(reward.rewardKey);
    return Container(
      width: 0.95.sw,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.white, width: 4.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Cena: ${reward.prize}',
            style: GoogleFonts.titanOne(
              fontSize: 14.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            'Vyzdvihnuté: ${_formatDate(claimedAt)}',
            style: GoogleFonts.titanOne(
              fontSize: 14.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return 'Neznámy dátum';
    try {
      final parsed = DateTime.parse(isoString);
      return '${parsed.day}.${parsed.month}.${parsed.year}';
    } catch (_) {
      return isoString;
    }
  }
}
