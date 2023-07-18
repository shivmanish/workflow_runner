/*
Copyright (c) 2010-present by Jaxl Innovations Private Limited.

All rights reserved.

Redistribution and use in source and binary forms,
with or without modification, is strictly prohibited.
*/

part of jaxl_shared;

class RewardLevels extends StatefulWidget {
  final List<ListRewardLevel> listRewardLevel;
  final int currentLevelIndex;
  const RewardLevels({
    required this.listRewardLevel,
    required this.currentLevelIndex,
  });

  @override
  State<RewardLevels> createState() => _RewardLevelsState();
}

class _RewardLevelsState extends State<RewardLevels> {
  int clickedRewardLevelIndex = -1;

  @override
  void initState() {
    super.initState();
    clickedRewardLevelIndex = widget.currentLevelIndex;
    BlocProvider.of<JaxlRewardLevelTaskBloc>(context).add(
        JaxlRewardLevelTaskListEvent(
            rewardLevel:
                widget.listRewardLevel[clickedRewardLevelIndex].level!.value,
            limit: 100,
            offset: 0));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listRewardLevel.length,
      itemBuilder: (context, index) {
        return Container(
          color: Color(0xFF1C1C1E),
          padding: EdgeInsets.fromLTRB(18, 20, 18, 20),
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (index != clickedRewardLevelIndex) {
                    BlocProvider.of<JaxlRewardLevelTaskBloc>(context).add(
                        JaxlRewardLevelTaskListEvent(
                            rewardLevel:
                                widget.listRewardLevel[index].level!.value,
                            limit: 100,
                            offset: 0));
                  }
                  setState(() {
                    clickedRewardLevelIndex = index == clickedRewardLevelIndex
                        ? widget.currentLevelIndex
                        : index;
                  });
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "LEVEL ${widget.listRewardLevel[index].level}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: levelTailWidget(index, clickedRewardLevelIndex),
                      )
                    ],
                  ),
                ),
              ),
              BlocListener<JaxlRewardLevelTaskBloc, JaxlResourceState>(
                listener: (context, state) {
                  if (state is JaxlResourceErrorState) {
                    // show error message
                  }
                },
                child: index == clickedRewardLevelIndex
                    ? BlocBuilder<JaxlRewardLevelTaskBloc, JaxlResourceState>(
                        builder: (context, state) {
                          if ((state is JaxlResourceInitialState ||
                              state is JaxlResourceListingState)) {
                            return JaxlCommon.instance.getShimmer(
                              itemCount: 4,
                            );
                          } else if (state is JaxlResourceListedState) {
                            final rewardLevelTaskListData =
                                state.response as JaxlListApiResponse<Reward>;
                            return RewardTasks(
                                rewards: rewardLevelTaskListData.results);
                          } else
                            return Container();
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget levelTailWidget(int index, int clickedRewardLevelIndex) {
    if (index < widget.currentLevelIndex) {
      return Container(
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: Color(0xFF32D158),
              child: Icon(Icons.check),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: index != clickedRewardLevelIndex
                  ? Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                    )
                  : Icon(
                      Icons.arrow_downward_rounded,
                      size: 14,
                    ),
            ),
          ],
        ),
      );
    } else if (index == widget.currentLevelIndex &&
        widget.currentLevelIndex != clickedRewardLevelIndex) {
      return Container(
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
                radius: 8, backgroundColor: Color.fromARGB(255, 235, 182, 68)),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                )),
          ],
        ),
      );
    } else if (index > widget.currentLevelIndex) {
      return Icon(
        Icons.lock,
        size: 18,
      );
    }
    return Container();
  }
}
