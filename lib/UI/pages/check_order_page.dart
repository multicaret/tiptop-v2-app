import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiptop_v2/UI/widgets/address_select_button.dart';
import 'package:tiptop_v2/UI/widgets/app_scaffold.dart';
import 'package:tiptop_v2/providers/app_provider.dart';
import 'package:tiptop_v2/providers/home_provider.dart';

class CheckOrderPage extends StatefulWidget {
  static const routeName = '/check-order';
  @override
  _CheckOrderPageState createState() => _CheckOrderPageState();
}

class _CheckOrderPageState extends State<CheckOrderPage> {
  bool _isInit = true;
  HomeProvider homeProvider;
  AppProvider appProvider;
  double centerLat;
  double centerLong;
  LatLng initCameraPosition;

  double defaultZoom = 4.0;

  BitmapDescriptor orderIcon;
  BitmapDescriptor homeIcon;
  List<Marker> allMarkers = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      homeProvider = Provider.of<HomeProvider>(context);
      appProvider = Provider.of<AppProvider>(context);
      centerLat = (HomeProvider.branchLat + AppProvider.latitude) / 2;
      centerLong = (HomeProvider.branchLong + AppProvider.longitude) / 2;
      initCameraPosition = LatLng(centerLat, centerLong);

      BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/home_pin.png').then((value) => homeIcon = value);
      BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/home_pin.png').then((value) => orderIcon = value);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('Check your order'),
      ),
      body: Column(
        children: [
          AddressSelectButton(),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: initCameraPosition, zoom: defaultZoom),
                mapType: MapType.normal,
                markers: Set.from(allMarkers),
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      // add marker
      allMarkers.add(
        Marker(
          markerId: MarkerId('Home'),
          draggable: false,
          icon: orderIcon,
          position: LatLng(AppProvider.latitude, AppProvider.longitude),
        ),
      );
      allMarkers.add(
        Marker(
          markerId: MarkerId('Order'),
          draggable: false,
          icon: homeIcon,
          position: LatLng(HomeProvider.branchLat, HomeProvider.branchLong),
        ),
      );
    });
  }
}
