import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/reward_menu/model/reward_model.dart';
import 'package:haravara/pages/reward_menu/service/reward_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdminActualRewardsScreen extends ConsumerStatefulWidget {
  const AdminActualRewardsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminActualRewardsScreen> createState() =>
      _AdminRewardsHelperScreenState();
}

class _AdminRewardsHelperScreenState extends ConsumerState<AdminActualRewardsScreen> {
  List<Reward> rewards = [];
  Map<String, RewardInfo> rewardDefinitions = {};

  @override
  void initState() {
    super.initState();
    _loadCachedRewards();
    _fetchRewards();
  }

  Future<void> _loadCachedRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedDefinitions = prefs.getString('rewardDefinitions');
    
    if (cachedDefinitions != null) {
      final data = jsonDecode(cachedDefinitions) as Map<String, dynamic>;
      rewardDefinitions = data.map((key, value) => MapEntry(
          key,
          RewardInfo(
              name: value['name'],
              requiredStamps: value['requiredStamps'],
              color: value['color'],
              text: value['text'],
          )));
      setState(() {}); 
    }
  }

  Future<void> _fetchRewards() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final DatabaseReference rewardsRef = FirebaseDatabase.instance.ref().child('rewardDefinitions');
      final DataSnapshot snapshot = await rewardsRef.get();

      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        rewardDefinitions = data.map((key, value) => MapEntry(
            key,
            RewardInfo(
                name: value['name'],
                requiredStamps: value['requiredStamps'],
                color: value['color'],
              text: value['text'],
            )));

        final definitionsJson = jsonEncode(rewardDefinitions.map((key, info) => MapEntry(
            key, {'name': info.name, 'requiredStamps': info.requiredStamps})));
        await prefs.setString('rewardDefinitions', definitionsJson);
        setState(() {}); 
      }
    } catch (e) {
      print("Error fetching reward definitions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/backgrounds/verification_background.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h),
            child: const Header(),
          ),
          Positioned(
            top: 67.h,
            right: 30.w,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  'assets/menu-icons/backbutton.png',
                  width: 36.w,
                  height: 36.h,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 120.h, left: 16.w, right: 16.w),
            child: rewards.isEmpty
                ? _buildCachedRewardsList()
                : ListView.builder(
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _buildRewardContainer(reward),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCachedRewardsList() {
    return ListView.builder(
      itemCount: rewardDefinitions.length,
      itemBuilder: (context, index) {
        final key = rewardDefinitions.keys.elementAt(index);
        final info = rewardDefinitions[key]!;
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _buildRewardInfoContainer(info),
        );
      },
    );
  }

  Widget _buildRewardContainer(Reward reward) {
    final RewardInfo? info = rewardDefinitions[reward.rewardKey];

    if (info == null) {
      print("No matching reward definition found for key: ${reward.rewardKey}");
      return Container();
    }

    return _buildRewardInfoContainer(info);
  }

  Widget _buildRewardInfoContainer(RewardInfo info) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Color(info.color),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.name,
            style: GoogleFonts.titanOne(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Cena za ${info.requiredStamps} nazbieraných pečiatok',
            style: GoogleFonts.titanOne(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
