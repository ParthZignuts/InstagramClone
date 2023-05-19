import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;
import 'package:location/location.dart' as loc;

import '../../../core/core.dart';
import '../../../utils/utils.dart';

class SocioMap extends StatefulWidget {
  const SocioMap({Key? key}) : super(key: key);

  @override
  _SocioMapState createState() => _SocioMapState();
}

class _SocioMapState extends State<SocioMap> {
  final MapController _mapController = MapController();
  final loc.Location _location = loc.Location();
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    final loc.LocationData currentLocation = await _location.getLocation();
    if (currentLocation != null) {
      setState(() {
        _currentLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });

      // Calculate the zoom level based on a desired distance
      final double zoomLevel = calculateZoomLevel(double.infinity);

      // Zoom to the user's location
      _mapController.move(_currentLocation!, zoomLevel);
    }
  }

  double calculateZoomLevel(double desiredDistanceInMeters) {
    // Formula to calculate zoom level based on desired distance
    final double metersPerPixel =
        156543.03392 * math.cos(_currentLocation!.latitude * math.pi / 180) / math.pow(2, _mapController.zoom!);
    final double desiredZoomLevel = math.log(desiredDistanceInMeters * 2 / metersPerPixel) / math.ln2;
    return desiredZoomLevel.roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.getUser;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                zoom: 13,
                center: AppConstants.myLocation,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/parthakbari/clhu35gtg003001pig9cbfo66/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicGFydGhha2JhcmkiLCJhIjoiY2xodTMwaWJwMG5tNjNlcDVrMnM0ZmNyeiJ9.1hkpsINUNOi_KEbN2VUkGA",
                  additionalOptions: const {
                    'mapStyleId': AppConstants.mapBoxStyleId,
                    'accessToken': AppConstants.mapBoxAccessToken,
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentLocation ?? AppConstants.myLocation,
                      builder: (ctx) => Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user!.photoUrl),
                          ),
                          Text(
                            user!.userName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_currentLocation == null)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
