import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/reward_menu/model/reward_model.dart';
import 'package:haravara/pages/reward_menu/service/reward_service.dart';
import 'package:haravara/pages/reward_menu/view/reward_details_screen.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';

import '../../../core/widgets/close_button.dart';

class RewardScreen extends ConsumerStatefulWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends ConsumerState<RewardScreen> {
  final RewardService rewardService = RewardService();
  late String userId;
  late String username;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(userInfoProvider);
    userId = currentUser.id;
    username = currentUser.username;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    final collectedPlacesAsyncValue = ref.watch(collectedPlacesProvider(userId));
    return collectedPlacesAsyncValue.when(
      data: (collectedPlaceIds) {
        final collectedStamps = collectedPlaceIds.length;
        return FutureBuilder<List<Reward>>(
          future: rewardService.generateUserRewards(ref.read(userInfoProvider), collectedStamps),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading rewards'));
            }

            final rewards = snapshot.data!;
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
                      Footer(height: 50),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Column(
                      children: [
                        const Header(),
                        SizedBox(height: 5.h),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 40.h),
                                for(var reward in rewards)
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.h),
                                    child: buildRewardButton(context, reward.text, reward, Color(reward.color) , username),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 43.h,
                    right: 30.w,
                    child: Close_Button(),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading places: $error')),
    );
  }

  Widget buildRewardButton(BuildContext context, String buttonText, Reward reward, Color color, String username) {
    final isButtonEnabled = reward.isUnlocked && !reward.isClaimed;
    return ElevatedButton(
      onPressed: isButtonEnabled
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewardDetailsScreen(reward: reward, username: username),
                ),
              )
          : null,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(160.w, 40.h),
        backgroundColor: isButtonEnabled ? color : Colors.grey,
        side: const BorderSide(color: Colors.white, width: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.titanOne(fontSize: 14.sp, color: Colors.white),
      ),
    );
  }
}
