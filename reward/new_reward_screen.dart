/*
Copyright (c) 2010-present by Jaxl Innovations Private Limited.

All rights reserved.

Redistribution and use in source and binary forms,
with or without modification, is strictly prohibited.
*/

part of jaxl_shared;

class NewRewardScreewn extends StatefulWidget {
  const NewRewardScreewn({super.key});

  @override
  State<NewRewardScreewn> createState() => _NewRewardScreewnState();
}

class _NewRewardScreewnState extends State<NewRewardScreewn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1c1c1e),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    JaxlRewardLevelBloc(() => JaxlApp.instance.userCookie)
                      ..add(JaxlRewardLevelListEvent(limit: 100, offset: 0)),
              ),
              BlocProvider(
                create: (context) =>
                    JaxlRewardLevelTaskBloc(() => JaxlApp.instance.userCookie),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                appBar(
                  'REWARD JOURNEY',
                  context,
                  withPopOnClose: true,
                  titleSize: 17.0,
                  color: Color(0xff1c1c1e),
                ),
                RewardStatusCard(),
                SizedBox(
                  height: 20,
                ),
                BlocListener<JaxlRewardLevelBloc, JaxlResourceState>(
                  listener: (context, state) {
                    if (state is JaxlResourceErrorState) {
                      // show error message
                    }
                  },
                  child: BlocBuilder<JaxlRewardLevelBloc, JaxlResourceState>(
                    builder: (context, state) {
                      if (state is JaxlResourceInitialState ||
                          state is JaxlResourceListingState) {
                        return JaxlCommon.instance.getShimmer(
                          itemCount: 6,
                        );
                      } else if (state is JaxlResourceListedState) {
                        final rewardLevelData = state.response
                            as JaxlListApiResponse<ListRewardLevel>;
                        return Expanded(
                            child: RewardLevels(
                          listRewardLevel: rewardLevelData.results,
                          currentLevelIndex: currentLevelIndex(rewardLevelData),
                        ));
                      } else
                        return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rewardCard() {
    return Stack(children: [
      Container(
          margin: EdgeInsets.only(top: 25, left: 12, right: 12),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: RadialGradient(
                  focalRadius: 8,
                  radius: 2.5,
                  center: Alignment(0.15, 2.0),
                  colors: [
                    Colors.white.withOpacity(1),
                    Color.fromARGB(255, 183, 238, 238).withOpacity(1),
                    Color.fromARGB(255, 245, 243, 252).withOpacity(1),
                    Colors.white.withOpacity(1),
                    // Color.fromARGB(255, 229, 201, 242).withOpacity(1),
                  ])),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: RadialGradient(
                    focalRadius: 10,
                    radius: 2.0,
                    center: Alignment(0.1, 1.5),
                    colors: [
                      Color.fromARGB(255, 228, 222, 250).withOpacity(1),
                      Color.fromARGB(255, 183, 238, 238).withOpacity(0.5),
                      Color.fromARGB(255, 228, 222, 250).withOpacity(0.7),
                      Colors.white.withOpacity(1),
                      Colors.white.withOpacity(1),
                      // Color.fromARGB(255, 229, 201, 242).withOpacity(1),
                    ])),
            child: Stack(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      shape: CircleBorder(),
                      margin: EdgeInsets.fromLTRB(15, 15, 10, 15),
                      elevation: 2,
                      child: Container(
                        width: 65.00,
                        height: 65.00,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/setting/reward_bg_sphere.png"),
                              fit: BoxFit.fill),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                              'assets/images/setting/reward_find_profile.png'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '% off',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text.rich(TextSpan(
                                text: 'on ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: 'Super plan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF9C63E5),
                                    ),
                                  )
                                ])),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/images/setting/reward_offer_timer_ico.svg',
                                    width: 14,
                                    height: 14),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'Valid for 3 days',
                                  style: const TextStyle(
                                    color: Color(0xFF8E8E93),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ]),
              Positioned(
                right: 5,
                top: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF9C63E5),
                  ),
                  child: Text(
                    'Buy Plan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 32,
                child: Text(
                  '\$11.9/month',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8E8E93),
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 15,
                child: Text(
                  '\$3.99/month',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9C63E5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ]),
          )),
    ]);
  }
}
