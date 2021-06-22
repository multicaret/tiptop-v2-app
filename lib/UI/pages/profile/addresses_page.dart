import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/app_wrapper.dart';
import 'package:tiptop_v2/UI/pages/profile/add_address_page.dart';
import 'package:tiptop_v2/UI/pages/walkthrough_page.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_loader.dart';
import 'package:tiptop_v2/UI/widgets/UI/app_scaffold.dart';
import 'package:tiptop_v2/UI/widgets/UI/dialogs/confirm_alert_dialog.dart';
import 'package:tiptop_v2/UI/widgets/UI/section_title.dart';
import 'package:tiptop_v2/UI/widgets/address/address_icon.dart';
import 'package:tiptop_v2/i18n/translations.dart';
import 'package:tiptop_v2/models/address.dart';
import 'package:tiptop_v2/providers/addresses_provider.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/cart_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';
import 'package:tiptop_v2/utils/constants.dart';
import 'package:tiptop_v2/utils/helper.dart';
import 'package:tiptop_v2/utils/styles/app_colors.dart';
import 'package:tiptop_v2/utils/styles/app_icons.dart';
import 'package:tiptop_v2/utils/styles/app_text_styles.dart';

class AddressesPage extends StatefulWidget {
  static const routeName = '/my-addresses';

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool _isInit = true;
  bool _isLoadingAddress = false;
  bool _isLoadingChangingAddress = false;
  bool _shouldPopAfterSelection = false;

  AddressesProvider addressesProvider;
  AppProvider appProvider;
  CartProvider cartProvider;
  HomeProvider homeProvider;

  List<Address> addresses = [];
  List<Kind> kinds = [];

  Future<void> _fetchAndSetAddresses() async {
    setState(() => _isLoadingAddress = true);
    try {
      final response = await addressesProvider.fetchAndSetAddresses(appProvider);
      if (response == 401) {
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          WalkthroughPage.routeName,
          (Route<dynamic> route) => false,
        );
        return;
      }
      addresses = addressesProvider.addresses;
      kinds = addressesProvider.kinds;
      setState(() => _isLoadingAddress = false);
    } catch (e) {
      showToast(msg: Translations.of(context).get("An error occurred!"));
      setState(() => _isLoadingAddress = false);
      Navigator.of(context).pop();
      throw e;
    }
  }

  Future<void> _changeSelectedAddressWithConfirmation(Address _selectedAddress) async {
    bool shouldClearExistingCart = false;
    if (homeProvider.channelIsMarket) {
      if (!cartProvider.noMarketCart) {
        //User wants to change address while he has filled cart
        final response = await showDialog(
          context: context,
          builder: (context) => ConfirmAlertDialog(
            title: 'Are you sure you want to change your selected Address? Your cart will be cleared',
          ),
        );
        if (response != null && response) {
          //User accepted changing address while he has filled cart, change address and clear cart
          await cartProvider.clearMarketCart(appProvider);
        } else {
          return;
        }
      }
    } else {
      if (!cartProvider.noFoodCart) {
        //User wants to change address while he has filled cart
        final response = await showDialog(
          context: context,
          builder: (context) => ConfirmAlertDialog(
            title: 'Are you sure you want to change your selected Address? Your cart will be cleared',
          ),
        );
        if (response != null && response) {
          //User accepted changing address while he has filled cart, change address and clear cart
          await cartProvider.clearFoodCart(context, appProvider, shouldNavigateToHome: false);
        } else {
          return;
        }
      }
    }
    await _changeSelectedAddress(_selectedAddress, shouldClearExistingCart: shouldClearExistingCart);
    showToast(msg: Translations.of(context).get("Changed address successfully", args: [_selectedAddress.kind.title]));
  }

  Future<void> _changeSelectedAddress(Address _selectedAddress, {bool shouldClearExistingCart = false}) async {
    setState(() => _isLoadingChangingAddress = true);
    await addressesProvider.changeSelectedAddress(_selectedAddress, shouldClearExistingCart: shouldClearExistingCart);
    setState(() => _isLoadingChangingAddress = false);
    if (_shouldPopAfterSelection) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(AppWrapper.routeName, (Route<dynamic> route) => false);
    }
  }

  Future<void> _deleteAddress(int _addressId) async {
    final response = await showDialog(
      context: context,
      builder: (context) => ConfirmAlertDialog(
        title: 'Are you sure you want to delete this address?',
      ),
    );
    if (response != null && response) {
      if (!cartProvider.noMarketCart) {
        await cartProvider.clearMarketCart(appProvider);
        print('cart cleared as well :( ');
      }
      await addressesProvider.deleteAddress(appProvider, _addressId);
      _fetchAndSetAddresses();
      showToast(msg: Translations.of(context).get("Successfully deleted address!"));
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      appProvider = Provider.of<AppProvider>(context);
      addressesProvider = Provider.of<AddressesProvider>(context);
      cartProvider = Provider.of<CartProvider>(context);
      homeProvider = Provider.of<HomeProvider>(context);
      final data = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (data != null) {
        _shouldPopAfterSelection = data['should_pop_after_selection'] ?? false;
      }
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
              child: const AppLoader(),
            )
          : RefreshIndicator(
              onRefresh: _fetchAndSetAddresses,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (addresses.length > 0) SectionTitle('Your Addresses'),
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
      bool isSelectedAddress = addressesProvider.selectedAddress != null && addressesProvider.selectedAddress.id == addresses[i].id;
      return Material(
        color: AppColors.white,
        child: InkWell(
          onTap: isSelectedAddress ? null : () => _changeSelectedAddressWithConfirmation(addresses[i]),
          child: Container(
            width: double.infinity,
            height: addressListItemHeight,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: listItemVerticalPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              AddressIcon(
                                icon: addresses[i].kind.icon,
                                isAsset: false,
                              ),
                              Text(addresses[i].kind.title),
                              const SizedBox(width: 5),
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
                          child: AppIcons.icon(FontAwesomeIcons.trashAlt),
                          style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap, minimumSize: Size(20, 20)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSelectedAddress)
                  Container(
                    color: AppColors.secondary,
                    width: 30,
                    height: addressListItemHeight,
                    child: AppIcons.iconXsWhite(FontAwesomeIcons.check),
                  ),
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
                'should_pop_after_address_creation': _shouldPopAfterSelection,
              },
            ).then((shouldPop) {
              if (shouldPop != null && shouldPop) {
                Navigator.of(context).pop();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: screenHorizontalPadding, vertical: 20),
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
                        icon: kinds[i].icon,
                        isAsset: false,
                      ),
                      appProvider.isRTL
                          ? Text('${Translations.of(context).get("Add Address")} ${kinds[i].title}')
                          : Text('${Translations.of(context).get("Add")} ${kinds[i].title} ${Translations.of(context).get("Address")}')
                    ],
                  ),
                ),
                AppIcons.iconSm(FontAwesomeIcons.plus)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
