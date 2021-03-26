import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/pages/add_address_page.dart';
import 'package:tiptop_v2/UI/widgets/address_icon.dart';
import 'package:tiptop_v2/UI/widgets/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/section_title.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icon.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AddressesPage extends StatefulWidget {
  static const routeName = '/my-addresses';

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  bool _isInit = true;
  bool _isLoadingAddress = false;
  AddressesProvider addressesProvider;
  AppProvider appProvider;
  List<Address> addresses = [];
  List<Kind> kinds = [];

  Future<void> _fetchAndSetAddresses() async {
    setState(() => _isLoadingAddress = true);
    final response = await addressesProvider.fetchAndSetAddresses(appProvider);
    if (response == 401) {
      print('not authenticated!');
      return;
    }
    addresses = addressesProvider.addresses;
    kinds = addressesProvider.kinds;
    setState(() => _isLoadingAddress = false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      _fetchAndSetAddresses();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      body: _isLoadingAddress
          ? Center(
              child: AppLoader(),
            )
          : RefreshIndicator(
              onRefresh: _fetchAndSetAddresses,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ..._getAddressesItems(),
                    SectionTitle('Add Address'),
                    ..._getAddressKindsList(),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _getAddressesItems() {
    return List.generate(addresses.length, (i) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  AddressIcon(
                    isRTL: appProvider.isRTL,
                    icon: addresses[i].kind.icon,
                    isAsset: false,
                  ),
                  Text(addresses[i].kind.title),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      addresses[i].address1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body50,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                //Todo: implement deleting address
              },
              child: AppIcon.icon(FontAwesomeIcons.trashAlt),
              style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap, minimumSize: Size(20, 20)),
            )
          ],
        ),
      );
    });
  }

  List<Widget> _getAddressKindsList() {
    return List.generate(
      kinds.length,
      (i) => Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              AddAddressPage.routeName,
              arguments: {
                'kind': kinds[i],
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AddressIcon(
                        isRTL: appProvider.isRTL,
                        icon: kinds[i].icon,
                        isAsset: false,
                      ),
                      appProvider.isRTL
                          ? Text('${Translations.of(context).get('Add Address')} ${kinds[i].title}')
                          : Text('${Translations.of(context).get('Add')} ${kinds[i].title} ${Translations.of(context).get('Address')}')
                    ],
                  ),
                ),
                AppIcon.iconSm(FontAwesomeIcons.plus)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
