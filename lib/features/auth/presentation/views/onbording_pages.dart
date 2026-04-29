import 'package:flutter/material.dart';

import 'package:p/core/shared/widgets/onbording.dart';

import 'package:p/features/auth/presentation/views/signup_view.dart';

import 'package:p/features/auth/presentation/widgets/back_button.dart';

class PageViewOnbording extends StatelessWidget {
  PageViewOnbording({super.key});
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: [
        Onbording(
          controller: controller,
          icon: Icons.search,
          title: "Search for the service you want",
          button: () {
            controller.animateToPage(
              1,
              duration: Duration(milliseconds: 500),
              curve: Curves.linear,
            );
          },
          buttonText: "Next",
          supTitle: "An advanced search engine to help you find what you need",
          back: SizedBox(),
        ),
        Onbording(
          controller: controller,
          icon: Icons.token,
          title: "Show your experiences",
          button: () {
            controller.animateToPage(
              2,
              duration: Duration(milliseconds: 500),
              curve: Curves.linear,
            );
          },
          buttonText: "Next",
          supTitle: "Offer your solutions, help others",
          back: BackButtonPage(
            ontap: () {
              controller.animateToPage(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            },
          ),
        ),
        Onbording(
          controller: controller,
          icon: Icons.add_card_outlined,
          title: "Start earning money",
          button: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUpView()),
            );
          },
          buttonText: "Start",
          supTitle: "Provide solutions and complete requests to earn money",
          back: BackButtonPage(
            ontap: () {
              controller.animateToPage(
                1,
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            },
          ),
        ),
      ],
    );
  }
}
