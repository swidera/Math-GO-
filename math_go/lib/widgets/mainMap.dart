//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
//import 'package:dynamic_theme/dynamic_theme.dart';
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
import '../models/populateRandomBeasties.dart';
import 'dart:math';

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
  Location location = Location();
  Set<Marker> _markers = Set<Marker>();
  //GoogleMapController _controller;
  Completer<GoogleMapController> _controller = Completer();

  //BitMap Variables
  BitmapDescriptor sourceIcon;
  List<BitmapDescriptor> beastieBitMap = new List<BitmapDescriptor>();

  //Beastie Variables
  var beastieCount = 0;
  List<beastieInfo> beastiesToSpawn = new List<beastieInfo>();
  List<beastieInfo> testBeastiesToSpawn = new List<beastieInfo>();

  CameraPosition initialCameraPosition;


  // void initState() {
  //   super.initState();

  //   location = new Location();

    // location.onLocationChanged().listen((LocationData cLoc) {
    //     currentLocation = cLoc;
    //     updatePinOnMap();
    // });

  // }

  Future<bool> getMapData() async{
    beastiesToSpawn = await populateRandomBeasties();

    testBeastiesToSpawn.add(new beastieInfo("Eagle", "easy", "2 + 2", 4, 'assets/eagle-emblem.png'));

    await setIcons(testBeastiesToSpawn);
    
    await setInitialLocation();

    await showPinsOnMap(beastieBitMap, testBeastiesToSpawn);

    //setState(() {});

    return true;
  }

  //Free use icons come from https://game-icons.net/
  //Setting up icon for player
  Future<void> setIcons(List<beastieInfo> beastiesList) async {

    beastiesList.add(new beastieInfo("Eagle", "easy", "2 + 2", 4, 'assets/eagle-emblem.png'));

    //TO DO: go through list and set up each icon
    Size imageSize = Size(1, 1);
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: imageSize),
        'assets/plane-pilot.png');

    for(var i = 0; i < beastiesList.length; i++) {
      beastieBitMap.add(await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1, size: imageSize),
          beastiesList[i].imageUrl.toString()));
    }
    
  }

  //setting initial location
  Future<void> setInitialLocation() async {
    currentLocation = await location.getLocation();
    initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    location.onLocationChanged().listen((LocationData cLoc) {
        currentLocation = cLoc;
        updatePinOnMap();
    });
  }

  //function to show markers on google maps of beasties and player
  Future<void> showPinsOnMap(List<BitmapDescriptor> beastieBitMap, List<beastieInfo> beastiesList) {
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

    //Player marker
    _markers.add(Marker(
      markerId: MarkerId('sourcePin') ,
      position: pinPosition,
      icon: sourceIcon,
    ));
    //Beastie markers

    //TO DO: go through list and add each marker
    for(var i = 0; i < beastieBitMap.length; i++) {
      var randX = new Random();
      var randY = new Random();
      var posRandX = new Random();
      var posRandY = new Random();

      var randLat = 0.0;
      var randLong = 0.0;

      randLat = (randX.nextInt(10) + 1)*0.001;
      randLong = (randY.nextInt(10) + 1) *0.001;

      if (posRandX.nextInt(1) == 0) {
        randLat = randLat * (-1);
      }
      
      if (posRandY.nextInt(1) == 0) {
        randLong = randLong * (-1);
      }

      var randPosition = LatLng(currentLocation.latitude + randLat, currentLocation.longitude + randLong);

      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: randPosition,
        icon: beastieBitMap[i],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BeastieAr(loggedInUser: widget.loggedInUser, beastie: beastiesList[i])),
          );
        }
      ));
    }
    
    //setState(() {});
  }

  Future<void> updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

  //  setState(() {
      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.removeWhere(
        (m) => m.markerId.value == 'sourcePin');

      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon
      ));

  //  });
    //setState(() {});
      
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
    return FutureBuilder<bool>(
          future: getMapData(),
          builder: (BuildContext buildContext, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done
                && snapshot.data
                && snapshot.hasData) {
                    return Scaffold(
                      //app bar 
                      appBar: AppBar(
                        title: Text('Math GO! Map Screen'),
                        backgroundColor: Colors.orange
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
                      body:googleMap()
                    );
                  }
              return Center(
                // Display Progress Indicator
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              );
            });
  }

Widget googleMap(){
    return Container(
        child: GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              //_controller=controller;
            }
        )
    );
  }

}

class MathGo extends StatefulWidget {
  final String loggedInUser;
  const MathGo(this.loggedInUser);

  State createState() => _MathGoState();
}

