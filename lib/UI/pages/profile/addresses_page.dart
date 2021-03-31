import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/profile/add_address_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/address/address_icon.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/helper.dart';
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
  bool _isLoadingChangingAddress = false;

  AddressesProvider addressesProvider;
  AppProvider appProvider;
  CartProvider cartProvider;
  HomeProvider homeProvider;

  List<Address> addresses = [];
  List<Kind> kinds = [];

  Future<void> _fetchAndSetAddresses() async {
    setState(() => _isLoadingAddress = true);
    final response = await addressesProvider.fetchAndSetAddresses(appProvider);
    if (response == 401) {
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(WalkthroughPage.routeName);
      return;
    }
    addresses = addressesProvider.addresses;
    kinds = addressesProvider.kinds;
    setState(() => _isLoadingAddress = false);
  }

  Future<void> _changeSelectedAddressWithConfirmation(Address _selectedAddress) async {
    if (!cartProvider.noCart) {
      //User wants to change address while he has filled cart
      showDialog(
        context: context,
        builder: (context) => ConfirmAlertDialog(
          title: 'Are you sure you want to change your selected Address? Your cart will be cleared',
        ),
      ).then((response) {
        if (response != null && response) {
          //User accepted changing address while he has filled cart, change address and clear cart
          cartProvider.clearCart(appProvider, homeProvider).then((_) {
            addressesProvider.changeSelectedAddress(_selectedAddress).then((_) {
              _changeSelectedAddress(_selectedAddress).then((_) {
                showToast(msg: 'Cleared cart and changed address to (${_selectedAddress.kind.title}) successfully!');
              });
            });
          });
        }
      });
    } else {
      _changeSelectedAddress(_selectedAddress).then((_) {
        showToast(msg: 'Changed address to (${_selectedAddress.kind.title}) successfully!');
      });
    }
  }

  Future<void> _changeSelectedAddress(Address _selectedAddress) async {
    setState(() => _isLoadingChangingAddress = true);
    await addressesProvider.changeSelectedAddress(_selectedAddress);
    setState(() => _isLoadingChangingAddress = false);
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppWrapper.routeName);
  }

  Future<void> _deleteAddress(int _addressId) async {
    final response = await showDialog(
      context: context,
      builder: (context) => ConfirmAlertDialog(
        title: 'Are you sure you want to delete this address?',
      ),
    );
    if (response != null && response) {
      if(!cartProvider.noCart) {
        await cartProvider.clearCart(appProvider, homeProvider);
        print('cart cleared as well :( ');
      }
      await addressesProvider.deleteAddress(appProvider, _addressId);
      _fetchAndSetAddresses();
      showToast(msg: 'Successfully deleted address!');
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      _fetchAndSetAddresses();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasCurve: false,
      hasOverlayLoader: _isLoadingChangingAddress,
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
      return Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () => _changeSelectedAddressWithConfirmation(addresses[i]),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
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
                  onPressed: () => _deleteAddress(addresses[i].id),
                  child: AppIcon.icon(FontAwesomeIcons.trashAlt),
                  style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap, minimumSize: Size(20, 20)),
                )
              ],
            ),
          ),
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
