

import 'package:dev_essentials/dev_essentials.dart';
import 'package:flutter/material.dart';


import 'buttons/common_button.dart';

class Error404View extends StatelessWidget {
  const Error404View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 50,
        children: [_buildVectorSections(context), _buildBackToHomeButton()],
      ),
    );
  }

  Widget _buildVectorSections(BuildContext context) {
    return _buildVectorSection(
      mainWidth: 350,
      vectorWidth: (context.width / 1.09),
      mainHeight: 150,
    );
  }

  Widget _buildVectorSection({
    required double mainWidth,
    required double vectorWidth,
    required double mainHeight,
    double? vectorHeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        Center(
          child: Image.asset(
            'assets/images/404.png',
            width: mainWidth,
            height: mainHeight,
          ),
        ),
        Image.asset(
          'assets/images/404_vector.png',
          width: vectorWidth,
          height: vectorHeight,
        ),
      ],
    );
  }

  Widget _buildBackToHomeButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Text('Page Not Found', textAlign: TextAlign.center),
        Text(
          'Sorry, the page you’re looking for does not exist or has been moved\nplease go back to the home page',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Center(
          child: CommonButton(
            text: 'Back to home',
            onPressed: () async {},

            textColor: Colors.white,
            radius: 500,

            width: 320,
            height: 52,
          ),
        ),
      ],
    );
  }
}
