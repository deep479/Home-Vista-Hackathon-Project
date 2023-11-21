import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucservice_customer/loginAuth/login_screen.dart';
import 'package:ucservice_customer/utils/color_widget.dart';
import 'package:ucservice_customer/utils/colors.dart';
import 'package:ucservice_customer/utils/image_icon_path.dart';
import 'package:ucservice_customer/utils/text_widget.dart';

class PagviewOnordingScreen extends StatefulWidget {
  const PagviewOnordingScreen({Key? key}) : super(key: key);

  @override
  State<PagviewOnordingScreen> createState() => _PagviewOnordingScreenState();
}

class _PagviewOnordingScreenState extends State<PagviewOnordingScreen> {
  PageController controller = PageController();
  late ColorNotifire notifire;
  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  final List<OnBoardModel> onBoardData = [
    const OnBoardModel(
      title: TextString.Beautyparlouratyourhome,
      description: TextString.loremIpsumFont,
      imgUrl: ImagePath.onboarding_1_img,
    ),
    const OnBoardModel(
      title: TextString.Plumberexpartnearbyyou,
      description: TextString.loremIpsumFont,
      imgUrl: ImagePath.onboarding_2_img,
    ),
    const OnBoardModel(
      title: TextString.Professionalhomecleaning,
      description: TextString.loremIpsumFont,
      imgUrl: ImagePath.onboarding_3_img,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
        backgroundColor: notifire.getprimerycolor,
        body: OnBoard(
          imageWidth: Get.width,
          pageController: controller,
          onSkip: () {},
          onDone: () {},
          pageIndicatorStyle: PageIndicatorStyle(
              width: 100,
              inactiveColor: Colors.indigoAccent.shade100,
              activeColor: CustomColors.primaryColor,
              inactiveSize: const Size(8, 8),
              activeSize: const Size(12, 12)),
          onBoardData: onBoardData,
          titleStyles: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: 22,
              fontFamily: CustomColors.fontFamily,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.15),
          descriptionStyles:
              const TextStyle(fontSize: 16, color: CustomColors.grey),
          skipButton:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.asset(ImagePath.curvePinkImg, scale: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: CustomColors.accentColor),
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                        color: CustomColors.black,
                        fontFamily: CustomColors.fontFamily),
                  ),
                ),
              ),
            ),
          ]),
          nextButton: OnBoardConsumer(
            builder: (context, ref, child) {
              final state = ref.watch(onBoardStateProvider);
              return InkWell(
                onTap: () => _onNextTap(state),
                child: state.isLastPage
                    ? InkWell(
                        onTap: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: Container(
                            height: 48,
                            width: 166,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: CustomColors.primaryColor),
                            child: const Center(
                                child: Text(
                              TextString.getStarted,
                              style: TextStyle(
                                  color: CustomColors.white,
                                  fontFamily: CustomColors.fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ))),
                      )
                    : CircleAvatar(
                        radius: 28,
                        backgroundColor: CustomColors.primaryColor,
                        child: state.isLastPage
                            ? const SizedBox.shrink()
                            : const Icon(
                                Icons.arrow_forward_ios,
                                color: CustomColors.white,
                              ),
                      ),
              );
            },
          ),
        ));
  }

  /// On Next tap
  void _onNextTap(OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      controller.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {}
  }
}
