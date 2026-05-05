import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p/features/splash_and_onboarding/presentation/widgets/onbording.dart';

import 'package:p/features/auth/presentation/view_model/user_session/user_session_bloc.dart';
import 'package:p/features/auth/presentation/views/login_view.dart';
import 'package:p/features/auth/presentation/widgets/back_button.dart';

class PageViewOnbording extends StatelessWidget {
  PageViewOnbording({super.key});

  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserSessionBloc, UserSessionState>(
      listener: (context, state) {
        if (state is UserUnAuth) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        }
      },
      child: PageView(
        controller: controller,
        children: [
          Onbording(
            controller: controller,
            icon: Icons.search,
            title: 'Search for the service you want',
            supTitle:
                'An advanced search engine to help you find what you need',
            buttonText: 'Next',
            button: () => controller.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
            back: const SizedBox(),
          ),
          Onbording(
            controller: controller,
            icon: Icons.token,
            title: 'Show your experiences',
            supTitle: 'Offer your solutions, help others',
            buttonText: 'Next',
            button: () => controller.animateToPage(
              2,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
            back: BackButtonPage(
              ontap: () => controller.animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Onbording(
            controller: controller,
            icon: Icons.add_card_outlined,
            title: 'Start earning money',
            supTitle: 'Provide solutions and complete requests to earn money',
            buttonText: 'Start',

            button: () =>
                context.read<UserSessionBloc>().add(const CompleteOnboarding()),
            back: BackButtonPage(
              ontap: () => controller.animateToPage(
                1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
