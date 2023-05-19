import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../../../core/model/user_location.dart';
import '../../../core/providers/providers.dart';
import '../../../core/model/user.dart' as model;
import '../../../utils/global_variables.dart';

class SocioMap extends StatefulWidget {
  const SocioMap({Key? key,required this.uid}) : super(key: key);
final String uid;

  @override
  _SocioMapState createState() => _SocioMapState();
}

class _SocioMapState extends State<SocioMap> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late LocationData _currentLocation = LocationData.fromMap({
    'latitude': 0.0, // Set a default latitude value
    'longitude': 0.0, // Set a default longitude value
  });
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Location service is not enabled, handle it accordingly
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Location permission not granted, handle it accordingly
        return;
      }
    }

   setState(() async{
     _currentLocation = await location.getLocation();
   });
    _updateUserLocation();
  }

  Future<void> _updateUserLocation() async {
    if (widget.uid != null) {
       latitude = _currentLocation.latitude!;
       longitude = _currentLocation.longitude!;
      final location = LatLng(latitude!, longitude!);

      final userLocationData = {
        'latitude':latitude,
        'longitude':longitude,
      };

      await _firestore.collection('users').doc(widget.uid).set(userLocationData, SetOptions(merge: true));
    }
  }


  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 32, 32),
        title: const Text('Flutter MapBox'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userLocations = snapshot.data!.docs.map((doc) {
              final data = doc.data();
              print('Location Data: $data');
              final username = data?['userName'] ?? user!.userName;
              final latitude = data?['latitude'] as double?;
              final longitude = data?['longitude'] as double?;
              final location = (latitude != null && longitude != null)
                  ? LatLng(latitude, longitude)
                  : LatLng(0, 0); // Use default values when latitude or longitude is null
              final photoUrl = data?['photoUrl'] ?? user!.photoUrl;
              return UserLocation(
                username: username as String,
                location: location,
                photoUrl: photoUrl as String,
              );
            }).toList();

            return FlutterMap(
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                zoom: 13,
                center: _currentLocation != null
                    ? LatLng(_currentLocation.latitude!, _currentLocation.longitude!)
                    : LatLng(0, 0),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://api.mapbox.com/styles/v1/parthakbari/clhudsgzo003p01pibu0r55cy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicGFydGhha2JhcmkiLCJhIjoiY2xodTMwaWJwMG5tNjNlcDVrMnM0ZmNyeiJ9.1hkpsINUNOi_KEbN2VUkGA",
                  additionalOptions: const {
                    'mapStyleId': AppConstants.mapBoxStyleId,
                    'accessToken': AppConstants.mapBoxAccessToken,
                  },
                ),
                MarkerLayer(
                    markers: userLocations.map((userLocation) {
                      return Marker(
                        width: 100,
                        height: 60,
                        point: userLocation.location,
                        builder: (context) {
                          return Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userLocation.photoUrl),
                              ),
                              Text(userLocation.username, style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),

              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
