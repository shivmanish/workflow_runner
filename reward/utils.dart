part of jaxl_shared;

void openRewardsBottomSheet(BuildContext context,
    {required String completedTaskTitel,
    String? completedTaskSubTitel,
    required String nextTaskTitel,
    String? nextTaskSubTitel,
    required String totalCount,
    required String numCompleted,
    String? completedTaskImage,
    String? nextTaskImage,
    required Function onTapNextStep}) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      isDismissible: false,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(10))),
      context: context,
      builder: (context) {
        return FractionallySizedBox(
            heightFactor: 0.62,
            child: RewardScreen(
                completedTaskTitel: completedTaskTitel,
                completedTaskSubTitel: completedTaskSubTitel,
                nextTaskTitel: nextTaskTitel,
                nextTaskSubTitel: nextTaskSubTitel,
                totalCount: totalCount,
                numCompleted: numCompleted,
                onTapNextStepTile: onTapNextStep,
                completedTaskImage: completedTaskImage,
                nextTaskImage: nextTaskImage));
      });
}

void openLinkDeviceGuideBottomSheet() {
  showModalBottomSheet(
      backgroundColor: Color(0xFF1C1C1E),
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(10))),
      context: JaxlApp.instance.navigatorKey.currentContext!,
      builder: (context) {
        return FractionallySizedBox(
            heightFactor: 0.5, child: linkDeviceGuide());
      });
}

Widget linkDeviceGuide() {
  return Container(
    padding: const EdgeInsets.only(left: 15.0, right: 12, top: 15),
    child: Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            'How to access Web App?',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Spacer(),
          cancleButton(JaxlApp.instance.navigatorKey.currentContext!,
              buttonBgColor: Color(0xFF2C2C2E)),
        ]),
        const SizedBox(
          height: 25,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xFF9c63e5),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 2, bottom: 2),
                height: 25,
                width: 1,
                color: Color(0xFF9c63e5),
              ),
              linkDeviceGuideContent(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget linkDeviceGuideContent() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 4,
        backgroundColor: Color(0xFF9c63e5),
      ),
    ],
  );
}

Widget cancleButton(BuildContext context, {Color? buttonBgColor}) {
  return Card(
    elevation: 5,
    shape: CircleBorder(),
    child: GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: CircleAvatar(
        radius: 13,
        backgroundColor: buttonBgColor ?? Color(0xFFF2F2F7),
        child: Icon(
          Icons.close_rounded,
          size: 18,
          color: Color(0xFF8E8E93),
        ), // No matter how big it is, it won't overflow
      ),
    ),
  );
}

int currentLevelIndex(JaxlListApiResponse<ListRewardLevel> levelData) {
  for (ListRewardLevel result in levelData.results) {
    int currentIndex = levelData.results.indexOf(result);
    if (currentIndex == 0 &&
        levelData.results[currentIndex].percentageCompleted != 100) {
      return currentIndex;
    } else if (levelData.results[currentIndex - 1].percentageCompleted == 100 &&
        levelData.results[currentIndex].percentageCompleted != 100) {
      return currentIndex;
    }
  }
  return 0;
}

Widget toastMessage(
    {String? leadingImage,
    required String titel,
    String? subTitel,
    Function? onTileTap}) {
  return ListTile(
    dense: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    tileColor: Color(0xFF3A3A3C),
    contentPadding: EdgeInsets.fromLTRB(12, 0, 5, 0),
    // visualDensity: VisualDensity(vertical: -2),
    leading: leadingImage != null ? Image.asset(leadingImage) : SizedBox(),
    title: Text(
      titel,
      style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    ),
    subtitle: subTitel != null
        ? Text(
            subTitel,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF8E8E93),
            ),
          )
        : null,
    trailing: InkWell(
      onTap: () {
        JaxlApp.instance.hideToast();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Dismiss',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF8E8E93),
          ),
        ),
      ),
    ),
    onTap: () => onTileTap!(),
  );
}

class RewardStatusTile extends StatelessWidget {
  const RewardStatusTile(
      {super.key,
      this.tileLoaderAnimation,
      required this.taskStatus,
      this.margin,
      required this.title,
      this.subTitle,
      this.initialImage,
      this.completedImage,
      this.forwardActionImage,
      this.tileColor,
      this.onTap});

  final Animation<double?>? tileLoaderAnimation;
  final EdgeInsetsGeometry? margin;
  final bool taskStatus;
  final String title;
  final String? subTitle;
  final String? initialImage;
  final String? completedImage;
  final String? forwardActionImage;
  final Function? onTap;
  final Color? tileColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : () {},
      child: Container(
        margin: margin ?? const EdgeInsets.only(left: 20, right: 20),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: tileColor ?? Color(0xFF1C1C1E),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(40)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              height: 50,
              width: 50,
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                        maxRadius: 30,
                        minRadius: 10,
                        backgroundColor: Color(0xFF3A3A3C),
                        child: taskStatus
                            ? completedImage != null
                                ? Image.asset(completedImage!)
                                : Icon(
                                    Icons.check,
                                    size: 20,
                                  )
                            : initialImage != null
                                ? Image.asset(initialImage!)
                                : Icon(
                                    Icons.call,
                                    size: 20,
                                  )),
                  ),
                  Center(
                    child: CustomPaint(
                      painter: ArcIndicator(
                          radians: tileLoaderAnimation != null
                              ? tileLoaderAnimation!.value!
                              : 0,
                          fraction: 1,
                          bgColor: Color(0xFF3A3A3C),
                          completedColor: Color(0xFF32D158),
                          strockWidth: 5,
                          radius: 26),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  subTitle != null
                      ? Text(
                          subTitle!,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF8E8E93),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Spacer(),
            forwardActionImage != null
                ? Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.all(5),
                    child: Image.asset(
                      forwardActionImage!,
                      width: 25,
                      height: 20,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class AppLifecycleController with WidgetsBindingObserver {
  final Function(AppLifecycleState) lifecycleCallback;

  AppLifecycleController({required this.lifecycleCallback}) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    lifecycleCallback(state);
  }
}

class RewardLevelIcon extends StatelessWidget {
  final String levelColor;
  const RewardLevelIcon({
    required this.levelColor,
  });
  @override
  Widget build(BuildContext context) {
    print('========== $levelColor');
    return SvgPicture.string(
      '''<svg width="95" height="95" viewBox="0 0 95 95" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M46.5158 0.154048C47.0117 -0.0513494 47.5689 -0.0513491 48.0648 0.154048L80.073 13.4123C80.5689 13.6177 80.9629 14.0117 81.1683 14.5076L94.4265 46.5158C94.6319 47.0117 94.6319 47.5689 94.4265 48.0648L81.1683 80.073C80.9629 80.5689 80.5689 80.9629 80.073 81.1683L48.0648 94.4265C47.5689 94.6319 47.0117 94.6319 46.5158 94.4265L14.5076 81.1683C14.0117 80.9629 13.6177 80.5689 13.4123 80.073L0.154048 48.0648C-0.0513494 47.5689 -0.0513491 47.0117 0.154048 46.5158L13.4123 14.5076C13.6177 14.0117 14.0117 13.6177 14.5076 13.4123L46.5158 0.154048Z" fill="$levelColor"/>
<path opacity="0.2" d="M7.22056 48.106L18.2597 75.1313C18.4603 75.6224 18.8451 76.0125 19.3294 76.216L46.5449 87.6474C47.0292 87.8508 47.5734 87.8508 48.0577 87.6474L75.2732 76.216C75.7575 76.0126 76.1423 75.6224 76.3429 75.1313L87.616 47.5334C87.8052 47.0701 87.8159 46.5528 87.6481 46.0833L76.8561 19.6632C76.6555 19.1721 76.2707 18.7819 75.7864 18.5785L48.0632 6.93382C47.5789 6.73039 47.0347 6.73039 46.5504 6.93382L18.8271 18.5785C18.3429 18.7819 17.9581 19.1721 17.7575 19.6632L7.22056 45.4589C7.03242 45.9195 6.9447 46.4159 6.96341 46.9141C6.97879 47.3237 7.06586 47.7273 7.22056 48.106Z" fill="black"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M48.0566 1.37566C47.5641 1.17166 47.0107 1.17166 46.5182 1.37566L15.3668 14.279C14.8743 14.483 14.483 14.8743 14.279 15.3668L1.37566 46.5182C1.17166 47.0107 1.17165 47.5641 1.37566 48.0566L14.279 79.2081C14.483 79.7006 14.8743 80.0919 15.3668 80.2959L46.5182 93.1992C47.0107 93.4032 47.5641 93.4032 48.0566 93.1992L79.2081 80.2959C79.7006 80.0919 80.0919 79.7006 80.2959 79.2081L93.1992 48.0566C93.4032 47.5641 93.4032 47.0107 93.1992 46.5182L80.2959 15.3668C80.0919 14.8743 79.7006 14.483 79.2081 14.279L48.0566 1.37566ZM48.0566 3.60901C47.5641 3.40501 47.0107 3.40501 46.5182 3.60901L16.946 15.8582C16.4535 16.0622 16.0622 16.4535 15.8582 16.946L3.60901 46.5182C3.40501 47.0107 3.405 47.5641 3.60901 48.0566L15.8582 77.6288C16.0622 78.1213 16.4535 78.5126 16.946 78.7167L46.5182 90.9659C47.0107 91.1699 47.5641 91.1699 48.0566 90.9659L77.6288 78.7167C78.1213 78.5126 78.5126 78.1213 78.7167 77.6288L90.9659 48.0566C91.1699 47.5641 91.1699 47.0107 90.9659 46.5182L78.7167 16.946C78.5126 16.4535 78.1213 16.0622 77.6288 15.8582L48.0566 3.60901Z" fill="white"/>
<path opacity="0.21" d="M48.0582 6.93425C47.5657 6.73025 47.0123 6.73025 46.5198 6.93425L18.8424 18.5807C18.3499 18.7848 17.9586 19.1761 17.7546 19.6686L17.1406 21.2066C17.3446 20.7141 17.8336 20.3047 18.3261 20.1007L46.5198 8.24034C47.0123 8.03633 47.5657 8.03633 48.0582 8.24034L76.2517 20.0877C76.7442 20.2917 77.2728 20.7002 77.4768 21.1927L76.8518 19.6575C76.6478 19.165 76.2279 18.7717 75.7354 18.5677L48.0582 6.93425Z" fill="black"/>
<path d="M76.2169 66.6901H88.2728C88.449 67.4957 87.2204 68.8513 85.8503 70.363C84.262 72.1154 82.4837 74.0775 82.4837 75.6356C82.4837 77.7255 84.0572 78.9945 85.5291 80.1816C86.101 80.6429 86.6577 81.0918 87.1007 81.5717C88.367 82.9436 88.9914 84.5178 89.1453 85.1334L66.8735 86.2886L66.8723 86.2892V86.2887L66.8627 86.2892V82.5212C65.3281 82.9057 63.7542 83.3705 62.2823 83.9045C55.7451 86.276 51.2052 86.2582 47.9153 86.2453C47.6997 86.2444 47.4895 86.2436 47.2844 86.2435C47.0793 86.2436 46.8691 86.2444 46.6534 86.2453C43.3636 86.2582 38.8237 86.276 32.2865 83.9045C30.8178 83.3717 29.2476 82.9078 27.7162 82.5238V86.2892L27.7066 86.2887V86.2892L27.7054 86.2886L5.43359 85.1334C5.58749 84.5178 6.21189 82.9436 7.47827 81.5717C7.92126 81.0918 8.47789 80.6429 9.04987 80.1816C10.5218 78.9945 12.0953 77.7255 12.0953 75.6356C12.0953 74.0775 10.3169 72.1154 8.72863 70.363C7.35853 68.8513 6.12987 67.4957 6.30615 66.6901H18.3518C18.7778 65.2432 19.3976 63.7553 20.261 62.2539C23.8631 62.2535 27.8391 63.2618 32.0716 64.3351C36.8698 65.5519 41.9978 66.8524 47.2844 66.8614C52.571 66.8524 57.6989 65.5519 62.4972 64.3351C66.7297 63.2618 70.7056 62.2535 74.3078 62.2539C75.1712 63.7553 75.791 65.2432 76.2169 66.6901Z" fill="$levelColor"/>
<path opacity="0.14" d="M74.6939 81.2625C76.4132 78.4525 79.0902 70.5599 74.3141 62.2539C70.7119 62.2535 66.7359 63.2618 62.5034 64.3351C57.7052 65.5519 52.5773 66.8524 47.2906 66.8614C42.004 66.8524 36.8761 65.5519 32.0778 64.3351C27.8454 63.2618 23.8694 62.2535 20.2672 62.2539C15.491 70.5599 18.168 78.4525 19.8874 81.2625C22.2058 81.2625 27.7377 82.252 32.2928 83.9045C38.8299 86.276 43.3698 86.2582 46.6597 86.2453C46.8753 86.2444 47.0855 86.2436 47.2906 86.2435C47.4957 86.2436 47.706 86.2444 47.9216 86.2453C51.2115 86.2582 55.7513 86.276 62.2885 83.9045C66.8435 82.252 72.3755 81.2625 74.6939 81.2625Z" fill="white"/>
<path opacity="0.13" d="M18.3557 66.6914C16.4252 73.2485 18.4765 78.9618 19.8851 81.2638C21.4559 81.2638 24.5021 81.7181 27.7201 82.5251V86.2905L5.4375 85.1347C5.5914 84.5191 6.2158 82.9449 7.48217 81.573C7.92517 81.0931 8.4818 80.6442 9.05377 80.1829C10.5257 78.9959 12.0992 77.7269 12.0992 75.6369C12.0992 74.0788 10.3208 72.1167 8.73253 70.3643C7.36244 68.8527 6.13377 67.497 6.31005 66.6914H18.3557Z" fill="black"/>
<path opacity="0.13" d="M76.2215 66.6914C78.152 73.2485 76.1007 78.9618 74.6921 81.2638C73.1229 81.2638 70.0815 81.7171 66.8672 82.5225V86.2905L89.1498 85.1347C88.9959 84.5191 88.3715 82.9449 87.1051 81.573C86.6621 81.0931 86.1055 80.6442 85.5335 80.1829C84.0616 78.9959 82.4881 77.7269 82.4881 75.6369C82.4881 74.0788 84.2665 72.1167 85.8548 70.3643C87.2249 68.8527 88.4535 67.497 88.2773 66.6914H76.2215Z" fill="black"/>
<path opacity="0.3" d="M66.875 82.5181C70.0807 81.7154 73.1131 81.2631 74.6829 81.2617C73.4302 83.0933 69.4112 85.0799 66.875 86.2885V82.5181Z" fill="black"/>
<path opacity="0.3" d="M19.9062 81.2617C21.4806 81.2651 24.5116 81.7181 27.7141 82.5206V86.2884C25.1779 85.0799 21.1589 83.0933 19.9062 81.2617Z" fill="black"/>
<path d="M24.4296 76.683L26.6211 67.5625L28.2888 67.9632L26.4104 75.7808L30.4495 76.7513L30.1364 78.0542L24.4296 76.683Z" fill="white"/>
<path d="M32.9867 78.8143L35.1016 69.6758L41.0677 71.0565L40.7565 72.4012L36.4614 71.4072L35.8813 73.9138L39.7848 74.8171L39.4827 76.1226L35.5792 75.2193L34.9689 77.8564L39.264 78.8504L38.9528 80.1951L32.9867 78.8143Z" fill="white"/>
<path d="M46.2919 80.8181L42.7578 71.4766L44.5935 71.4562L47.331 79.0511L49.913 71.3973L51.7219 71.3773L48.3956 80.7948L46.2919 80.8181Z" fill="white"/>
<path d="M55.6756 80.201L53.8516 71L59.8585 69.8091L60.1269 71.163L55.8024 72.0203L56.3028 74.544L60.2329 73.7649L60.4935 75.0793L56.5633 75.8585L57.0897 78.5136L61.4142 77.6563L61.6826 79.0101L55.6756 80.201Z" fill="white"/>
<path d="M64.9471 78.3738L62.8359 69.2344L64.5071 68.8483L66.3167 76.6821L70.3641 75.7472L70.6657 77.0528L64.9471 78.3738Z" fill="white"/>
<path d="M48.0577 3.61392C47.5652 3.40994 47.0117 3.40994 46.5192 3.61392L16.947 15.8631C16.0751 16.2217 15.8136 16.8712 15.1777 18.5893L15.1719 18.6032C15.2733 18.5169 15.6257 18.1777 15.9357 17.9013C16.2193 17.6485 16.5553 17.4705 16.9067 17.3261L46.505 5.16146C47.0064 4.95378 47.5699 4.95378 48.0713 5.16146L77.1935 17.1315C77.8755 17.4119 78.4995 17.8095 79.0055 18.3459C79.2413 18.5957 79.4499 18.8182 79.5229 18.8805L79.5168 18.8658C78.7054 16.8373 78.5912 16.2227 77.6299 15.8631L48.0577 3.61392Z" fill="#DFDFDF"/>
</svg>''',
    );
  }
}
