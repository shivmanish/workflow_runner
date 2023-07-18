/*
Copyright (c) 2010-present by Jaxl Innovations Private Limited.

All rights reserved.

Redistribution and use in source and binary forms,
with or without modification, is strictly prohibited.
*/

part of jaxl_shared;

class RewardTasks extends StatefulWidget {
  const RewardTasks({
    super.key,
    required this.rewards,
  });

  final List<Reward> rewards;

  @override
  State<RewardTasks> createState() => _RewardTasksState();
}

class _RewardTasksState extends State<RewardTasks>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController taskCompletedController;
  Map<String, Animation<double?>> animationLoader = {};
  Map<String, Animation<double?>> taskCompletedAnimationLoader = {};

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(
            milliseconds:
                (2000 + ((completedTasks(widget.rewards) - 1) * 200))),
        vsync: this);
    buildAnimation(widget.rewards);

    controller.addListener(() {
      setState(() {});
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        taskCompletedController.forward();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.forward();
    });
  }

  int completedTasks(List<Reward> rewards) {
    int completedTask = 0;
    for (Reward reward in rewards) {
      if (reward.status == IdEnum.number1) {
        completedTask = completedTask + 1;
      }
    }
    return completedTask;
  }

  void buildAnimation(List<Reward> rewards) {
    animationLoader.clear();
    int completedTask = completedTasks(rewards);
    int i = completedTask - 1;
    for (Reward reward in rewards) {
      if (reward.status == IdEnum.number1) {
        animationLoader['animationLoader${rewards.indexOf(reward)}'] =
            Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(
            (((2000 + ((completedTask - 1) * 200)) - (2000 + (i * 200))) /
                (2000 + ((completedTask - 1) * 200))),
            ((2000) / (2000 + (i * 200))),
          ),
        ));
      }
      i = i - 1;
    }
    buildTaskAnimation();
  }

  void buildTaskAnimation() {
    taskCompletedAnimationLoader.clear();
    taskCompletedController = AnimationController(
        duration: Duration(milliseconds: (animationLoader.length) * 200),
        vsync: this);
    int i = 0;
    for (String key in animationLoader.keys) {
      taskCompletedAnimationLoader["taskCompleted$key"] =
          Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
        parent: taskCompletedController,
        curve: Interval(
          (i / (animationLoader.length)),
          ((i + 1) / (animationLoader.length)),
        ),
      ));
      i = i + 1;
    }

    taskCompletedController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    taskCompletedController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: widget.rewards.length,
          itemBuilder: (context, index) {
            return RewardStatusTile(
              tileLoaderAnimation:
                  widget.rewards[index].status == IdEnum.number1
                      ? animationLoader['animationLoader$index']
                      : null,
              taskStatus: widget.rewards[index].status == IdEnum.number1
                  ? taskCompletedAnimationLoader[
                              'taskCompletedanimationLoader$index']!
                          .value ==
                      100
                  : false,
              title: widget.rewards[index].title,
              subTitle: widget.rewards[index].subTitle,
              tileColor: Colors.black,
              margin:
                  const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 3),
            );
          }),
    );
  }
}
