/*
Copyright (c) 2010-present by Jaxl Innovations Private Limited.

All rights reserved.

Redistribution and use in source and binary forms,
with or without modification, is strictly prohibited.
*/

part of jaxl_shared;

class RewardStatusCard extends StatefulWidget {
  const RewardStatusCard({
    super.key,
  });

  @override
  State<RewardStatusCard> createState() => _RewardStatusCardState();
}

class _RewardStatusCardState extends State<RewardStatusCard>
    with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double?> loaderAnimation;
  int currentLevel = 0;
  final List<Color> levelCardColors = [
    Color(0xFFFF9F0A),
    Color(0xFF40C8E0),
    Color(0xFFFF453A),
    Color(0xFF4BA6EE),
    Color(0xFF67AD5B),
    Color(0xFF9031AA),
    Color(0xFF2179E1),
    Color(0xFFEC6337),
    Color(0xFFD63864),
  ];
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    loaderAnimation = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
  }

  void setLoaderAnimation(double? levelCompletedPercentage) {
    loaderAnimation = Tween<double>(begin: 0, end: levelCompletedPercentage)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ))
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JaxlRewardLevelBloc, JaxlResourceState>(
      listener: (context, state) {
        if (state is JaxlResourceListedState) {
          final rewardLevelData =
              state.response as JaxlListApiResponse<ListRewardLevel>;
          int currentIndex = currentLevelIndex(rewardLevelData);
          setState(() {
            currentLevel = rewardLevelData.results[currentIndex].level!.value;
          });
          if (controller.status != AnimationStatus.completed) {
            setLoaderAnimation(double.tryParse(
                "${rewardLevelData.results[currentIndex].percentageCompleted}"));
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 25, left: 15, right: 15),
        padding: EdgeInsets.all(5),
        // height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              transform: GradientRotation(math.pi / 3.2),
              end: Alignment(1, 1),
              colors: [
                Colors.white,
                Colors.white,
                levelCardColors[((currentLevel - 1) % (levelCardColors.length))]
                    .withOpacity(0.8),
              ]),
        ),
        child: Stack(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 100.80,
                  height: 95.64,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                            height: 90,
                            width: 90,
                            child: RewardLevelIcon(
                              levelColor:
                                  "#${levelCardColors[((currentLevel - 1) % (levelCardColors.length))].value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2, 8)}",
                            )),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            currentLevel < 9
                                ? '0$currentLevel'
                                : "$currentLevel",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8, left: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PROGRESS',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1C1C1E),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${num.parse((loaderAnimation.value!).toStringAsFixed(0))}% Completed',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Your Reward is waiting ....',
                          style: const TextStyle(
                            color: Color(0xFF8E8E93),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ]),
                ),
              ]),
        ]),
      ),
    );
  }
}
