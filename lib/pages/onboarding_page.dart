import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class OnboardingPage extends StatefulWidget {
  final Widget child; // The page to show the onboarding on
  final List<GlobalKey> keys; // Keys of the widgets to highlight

  const OnboardingPage({Key? key, required this.child, required this.keys}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    _initTutorial();
    Future.delayed(const Duration(milliseconds: 500), () {
      showTutorial();
    });
  }

  void _initTutorial() {
    List<TargetFocus> targets = [];

    // Example targets (you'll need to define these based on your HomePage widgets)
    // For now, this is a placeholder.
    if (widget.keys.isNotEmpty) {
      targets.add(
        TargetFocus(
          identify: widget.keys[0],
          keyTarget: widget.keys[0],
          alignSkip: Alignment.topRight,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome to Akontaa!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "This is your first step to managing your debts efficiently.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
