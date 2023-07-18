part of jaxl_shared;

class RewardScreen extends StatefulWidget {
  final String completedTaskTitel;
  final String? completedTaskSubTitel;
  final String nextTaskTitel;
  final String? nextTaskSubTitel;
  final String totalCount;
  final String numCompleted;
  final String? completedTaskImage;
  final String? nextTaskImage;
  final Function onTapNextStepTile;
  const RewardScreen({
    Key? key,
    required this.completedTaskTitel,
    this.completedTaskSubTitel,
    required this.nextTaskTitel,
    this.nextTaskSubTitel,
    this.completedTaskImage,
    this.nextTaskImage,
    required this.totalCount,
    required this.numCompleted,
    required this.onTapNextStepTile,
  }) : super(key: key);

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double?> loaderAnimation;
  late Animation<double?> tileLoaderAnimation;
  late Animation<double?> percentageAnimation;
  late AnimationController controller;
  bool isFirstStepDone = false;
  bool isvisibal = false;
  double completedPercentage = 0.0;
  double beginNum = 0.0;
  @override
  void initState() {
    super.initState();
    completedPercentage =
        (int.parse(widget.numCompleted) / int.parse(widget.totalCount)) * 100;
    if (int.parse(widget.numCompleted) >= 1) {
      beginNum = ((int.parse(widget.numCompleted) - 1) /
              int.parse(widget.totalCount)) *
          100;
    }
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    loaderAnimation = Tween<double>(begin: beginNum, end: completedPercentage)
        .animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.65,
        1,
        curve: Curves.ease,
      ),
    ));
    tileLoaderAnimation =
        Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.0,
        0.40,
      ),
    ))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                // isFirstStepDone = true;
              });
            }
          })
          ..addListener(() {
            setState(() {});
          });

    controller.forward();
  }

  void visibility() {
    if (!isFirstStepDone) {
      Future.delayed(Duration(milliseconds: 600), () {
        setState(() {
          isFirstStepDone = true;
        });
      });
    }
  }

  @override
  void dispose() {
    // dispose the controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (tileLoaderAnimation.value == 100) visibility();
    return Stack(
      children: [
        Positioned(
          top: 13,
          right: 17,
          child: cancleButton(context),
        ),
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            rewardBottomSheetHeaderTile(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 200.80,
              height: 200.64,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                        children: [
                          Text(
                            '${num.parse((loaderAnimation.value)!.toStringAsFixed(0))}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 41,
                            ),
                          ),
                          const Text(
                            'completed',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ]),
                  ),
                  Center(
                    child: CustomPaint(
                      painter: ArcIndicator(
                          radians: loaderAnimation.value!, fraction: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            actionRow(),
            const SizedBox(
              height: 20,
            ),
            Visibility(
                visible: isFirstStepDone ? false : true,
                child: RewardStatusTile(
                  tileLoaderAnimation: tileLoaderAnimation,
                  title: widget.completedTaskTitel,
                  subTitle: widget.completedTaskSubTitel,
                  taskStatus: tileLoaderAnimation.value == 100,
                  initialImage: widget.completedTaskImage,
                  completedImage: 'assets/images/setting/task_completed.png',
                )),
            Visibility(
              visible: isFirstStepDone ? true : false,
              child: RewardStatusTile(
                title: widget.nextTaskTitel,
                subTitle: widget.nextTaskSubTitel,
                taskStatus: false,
                initialImage: widget.nextTaskImage,
                forwardActionImage:
                    'assets/images/setting/forword_action_arrow.png',
                onTap: () {
                  if (completedPercentage == 25) Navigator.pop(context);
                  widget.onTapNextStepTile();
                },
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ],
    );
  }

  Widget actionRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'NEXT TASK',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1C1C1E),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                JaxlSettingsScreen.routeName + '/rewardJourney',
              );
            },
            child: Row(
              children: [
                const Text(
                  'View all',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                    String.fromCharCode(
                        Icons.arrow_forward_ios_rounded.codePoint),
                    style: TextStyle(
                      inherit: false,
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: Icons.arrow_forward_ios_rounded.fontFamily,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rewardBottomSheetHeaderTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Your Reward Journey',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'Complete all tasks to claim mega reward.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8E8E93),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
