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
                title: "Medicinal",
                message:
                    "Regista tu receta, valida tu tratamiento obten tu medicina",
                image: "assets/onBoard/medicine.svg",
              ),
              OnboardingMessages(
                left: 60,
                width: 0.60,
                height: 0.45,
                title: "Clubs",
                message:
                    "Suscríbete a clubes y recibe toda la información que necesitas.",
                image: "assets/onBoard/subscriber.svg",
              ),
              OnboardingMessages(
                left: 85,
                width: 0.50,
                height: 0.40,
                title: "Cultivar",
                message:
                    "Verifica y registra la evolución y el desarrollo de la medicina.",
                image: "assets/onBoard/gardening.svg",
              ),
              OnboardingMessages(
                left: 80,
                width: 0.60,
                height: 0.40,
                title: "Seguridad",
                message:
                    "Tus datos son confidenciales, tendrás toda la seguridad y soporte en tus manos.",
                image: "assets/onBoard/security.svg",
              ),
              OnboardingMessages(
                left: 75,
                width: 0.60,
                height: 0.40,
                title: "Ya estas listo!",
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
