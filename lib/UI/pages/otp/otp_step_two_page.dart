import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/data.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class OTPStepTwoPage extends StatelessWidget {
  static const routeName = '/otp-step-two';

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return AppScaffold(
      bgImage: 'assets/images/otp-bg-pattern.png',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              Translations.of(context).get('Phone Number Verification'),
              style: AppTextStyles.h2,
            ),
            SizedBox(height: 20),
            Text(
              '+(964) 555 333 11 22',
              style: AppTextStyles.h1,
              textDirection: TextDirection.ltr,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Translations.of(context).get('Is the number above correct?')),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    Translations.of(context).get('No, let me fix it'),
                    style: AppTextStyles.bodySecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            Text(
              Translations.of(context).get('choose preferred method'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ..._verificationMethodsList(context, appProvider),
          ],
        ),
      ),
    );
  }

  List<Widget> _verificationMethodsList(BuildContext context, AppProvider appProvider) {
    List verificationMethods = getVerificationMethods(context);

    return List.generate(verificationMethods.length, (i) {
      return Container(
        padding: EdgeInsets.only(bottom: i == verificationMethods.length - 1 ? 0 : 20),
        child: ElevatedButton(
            onPressed: verificationMethods[i]['action'],
            style: ElevatedButton.styleFrom(
              primary: verificationMethods[i]['color'],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: appProvider.dir == 'ltr' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Icon(verificationMethods[i]['icon']),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  flex: 3,
                  child: Text(
                    "${Translations.of(context).get('Continue Via')} ${verificationMethods[i]['name']}",
                  ),
                )
              ],
            )),
      );
    });
  }
}
