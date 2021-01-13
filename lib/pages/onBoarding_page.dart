import 'package:chat/controllers/slide_controler.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/widgets/onboarding_message.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    changeStatusLight();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: _size.height,
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff202020),
                Color(0xff1C3041),
              ],
              stops: [0, 1],
              begin: Alignment(-0.00, -5.00),
              end: Alignment(0.00, 5.00),
            ),
          ),
          child: OnBoardingSelector(
            pages: [
              OnboardingMessages(
                left: 80,
                width: 0.60,
                height: 0.40,
                title: "Medical",
                message:
                    "Register your prescription, validate your treatment get your medicine",
                image: "assets/onBoard/medicine.svg",
              ),
              OnboardingMessages(
                left: 60,
                width: 0.60,
                height: 0.45,
                title: "Clubes",
                message:
                    "Subscribe to clubes and receive all the information you need.",
                image: "assets/onBoard/subscriber.svg",
              ),
              OnboardingMessages(
                left: 85,
                width: 0.50,
                height: 0.40,
                title: "Cultivate",
                message:
                    "Check and record the evolution and development of your medicine.",
                image: "assets/onBoard/gardening.svg",
              ),
              OnboardingMessages(
                left: 80,
                width: 0.60,
                height: 0.40,
                title: "Safety",
                message:
                    "Your data is confidential, you will have all the safety and support in your hands.",
                image: "assets/onBoard/security.svg",
              ),
              OnboardingMessages(
                left: 75,
                width: 0.60,
                height: 0.45,
                title: "You are ready!",
                message: "",
                image: "assets/onBoard/celebration.svg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
