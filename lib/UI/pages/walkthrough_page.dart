import 'package:flutter/material.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class WalkthroughPage extends StatelessWidget {
  static const routeName = '/walkthrough';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/images/tiptop-logo.png',
            width: screenSize.width / 2.5,
          ),
          Container(
            child: Column(
              children: [
                Text('Continue Without Login'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    //Todo: If user location is selected, Navigate to Home Page.
                    // If not, navigate to location permission page
                  },
                  child: Text('Register'),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        // Todo: Navigate to OTP page
                      },
                      child: Text(
                        'Login',
                        style: AppTextStyles.bodySecondary,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
