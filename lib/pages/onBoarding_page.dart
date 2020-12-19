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
        child: Expanded(
          child: Container(
            width: double.infinity,
            height: _size.height,
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff202020),
                  Color(0xff1D1D1D),
                ],
                stops: [0, 1],
                begin: Alignment(-0.00, -5.00),
                end: Alignment(0.00, 5.00),
              ),
            ),
            child: OnBoardingSelector(
              pages: [
                OnboardingMessages(
                  title: "HELLO 2!",
                  message: "Know everything you need to know about your car",
                  image: "assets/images/img-intro-1.svg",
                ),
                OnboardingMessages(
                  title: "HELLO!",
                  message:
                      "Get assistance when ever you need, where ever you need",
                  image: "assets/images/img-intro-2.svg",
                ),
                OnboardingMessages(
                  title: "HELLO!",
                  message: "Take control of your car, make it a SmartCar",
                  image: "assets/images/img-intro-3.svg",
                ),
                OnboardingMessages(
                  title: "HELLO!",
                  message: "Take control of your car, make it a SmartCar",
                  image: "assets/images/img-intro-3.svg",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
