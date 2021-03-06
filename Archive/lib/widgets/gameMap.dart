import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'dart:async';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 45;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(45.512230, -122.658722);

class MathGo extends StatefulWidget {
  final String title;

  const MathGo({Key key, this.title}) : super(key: key);

  State createState() => _MathGoState();
}

class _MathGoState extends State<MathGo> {
  //brightness variable
  Brightness brightness;

  //map variables
  LocationData currentLocation;
  Location location;
  Set<Marker> _markers = Set<Marker>();
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon;

  void initState() {
    super.initState();

    location = new Location();

    location.onLocationChanged().listen((LocationData cLoc) {
        currentLocation = cLoc;
        updatePinOnMap();
    });

    setSourceIcons();

    setInitialLocation();

  }

  void setSourceIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
        'assets/plane-pilot.png');
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  void showPinsOnMap() {
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

    _markers.add(Marker(
      markerId: MarkerId('sourcePin') ,
      position: pinPosition,
      icon: sourceIcon
    ));
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {

      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.removeWhere(
        (m) => m.markerId.value == 'sourcePin');

      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon
      ));
    });
      
  }


  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION
    );

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude,
            currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING
      );
    }

    return Stack(
        children: <Widget>[
          GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              // my map has completed being created;
              // i'm ready to show the pins on the map
              showPinsOnMap();
          })
        ],
    );
  }
}