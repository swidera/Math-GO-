import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:location/location.dart';
import 'package:math_go/models/getLeaderboard.dart';
import 'dart:async';
import '../screens/loginScreen.dart';
import '../screens/leaderboardScreen.dart';
import '../screens/personalScoreScreen.dart';
import '../screens/beastiesScreen.dart';
import '../models/getPersonalScore.dart';
import '../models/getLeaderboard.dart';
import 'beastieAR.dart';
import '../models/getBeasties.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 60;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(45.512230, -122.658722);

//Resource Used for Google Map Implementation: https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#4



class _MathGoState extends State<MathGo> {
  //nav bar variables
  int pageIndex = 0;

  List<Widget> pageOptions = <Widget>[
  Text(
    'Main App'
  ),
  Text(
    'Beasties Page'
  ),
  Text(
    'Personal Score Page'
  ),
  Text(
    'Leaderboard'
  ),
  Text(
    'Logging out...'
  )
];

  //brightness variable
  Brightness brightness;

  //map variables
  LocationData currentLocation;
  Location location;
  Set<Marker> _markers = Set<Marker>();
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor beastieOne;
  BitmapDescriptor beastieTwo;
  BitmapDescriptor beastieThree;

  void initState() {
    super.initState();

    location = new Location();

    location.onLocationChanged().listen((LocationData cLoc) {
        currentLocation = cLoc;
        updatePinOnMap();
    });

    setIcons();

    setInitialLocation();

  }

  //Free use icons come from https://game-icons.net/
  //Setting up icon for player
  void setIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/plane-pilot.png');

    //setting up icons for temp beasties
    beastieOne = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/eagle-emblem.png');

    beastieTwo = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/angler-fish.png');

    beastieThree = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
        'assets/bully-minion.png');
  }

  //setting initial location
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  //function to show markers on google maps of beasties and player
  void showPinsOnMap() {
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

    //Player marker
    _markers.add(Marker(
      markerId: MarkerId('sourcePin') ,
      position: pinPosition,
      icon: sourceIcon,
    ));
    //Beastie markers
    var pinPositionOne = LatLng(currentLocation.latitude + 0.005 , currentLocation.longitude + 0.005);

    _markers.add(Marker(
      markerId: MarkerId('beastieOne') ,
      position: pinPositionOne,
      icon: beastieOne
    ));

    var pinPositionTwo = LatLng(currentLocation.latitude + 0.01 , currentLocation.longitude + 0.01);

    _markers.add(Marker(
      markerId: MarkerId('beastieTwo') ,
      position: pinPositionTwo,
      icon: beastieTwo
    ));

    var pinPositionThree = LatLng(currentLocation.latitude -0.005 , currentLocation.longitude - 0.005);

    _markers.add(Marker(
      markerId: MarkerId('beastieThree') ,
      position: pinPositionThree,
      icon: beastieThree
    ));

    setState(() {});
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

   void changePage(int pagePicked) async{

     if(pagePicked==4){
       Navigator.push(
       context,
         MaterialPageRoute(builder: (context) => loginScreen())
       );
     }

     if(pagePicked==3){
      List<leaderInfo> leaderboard = await getLeaderboard();
      Navigator.push(
         context,
       MaterialPageRoute(builder: (context) => leaderboardScreen(leaderboard, widget.loggedInUser))
       );
   }

     if(pagePicked==2){
      String lifeTimeScore = await getPersonalScore(widget.loggedInUser);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => personalScoreScreen(lifeTimeScore, widget.loggedInUser)
        )
      );
     }

     if(pagePicked==1){
       List<beastieInfo> myBeasties = await getUsersBeasties(widget.loggedInUser);
       Navigator.push(
         context,
        MaterialPageRoute(builder: (context) => beastiesScreen(myBeasties, widget.loggedInUser))
       );
     }

     setState(() {
       pageIndex = pagePicked;
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

    return Scaffold(
      //app bar 
      appBar: AppBar(
        title: Text('Math GO! Map Screen'),
        backgroundColor: Colors.blue
      ),
      bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.child_care),
                title: Text('Beasties'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.score),
                title: Text('Score'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Leaderboard'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.system_update_alt),
                title: Text('Logout'),
              ),
            ],
            currentIndex: pageIndex,
            selectedItemColor: Colors.deepOrangeAccent,
            onTap: changePage,
      ),
      body: Stack(
        children: <Widget>[
          //google map widget fall
          GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: true,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              // my map has completed being created;
              // i'm ready to show the pins on the map

              showPinsOnMap();
          }),
          Align (
            alignment: Alignment.bottomCenter,
            child: RaisedButton( 
              onPressed: () { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BeastieAr()),
                );
              },
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 5,
              child: const Text('AR Screen!'),
            ),
          ),
        ],
      ),
    );
  }
}

class MathGo extends StatefulWidget {
  final String loggedInUser;
  const MathGo(this.loggedInUser);

  State createState() => _MathGoState();
}
